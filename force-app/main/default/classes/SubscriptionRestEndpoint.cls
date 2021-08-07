@RestResource(urlMapping='/ActiveSubscriptions/*')
global with sharing class SubscriptionRestEndpoint {
    @HttpGet
    global static SubscriptionsWrapper getSubscriptions() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    SubscriptionsWrapper response = new SubscriptionsWrapper();

    // Get the ExternalID from the end of the URL
    String acctExternalId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

    List<Subscription__c> activeSubscriptions = [SELECT Account__r.FirstName__c, Account__r.LastName__c, Account__r.BirthDate__c, Name, Start_Date__c, End_Date__c 
                                                     FROM Subscription__c
                                                    WHERE Account__r.ExternalID__c = :acctExternalId
                                                      AND  Start_Date__c < TODAY
                                                      AND  End_Date__c   > TODAY];
    
    if(activeSubscriptions != null && activeSubscriptions.size() > 0) {
            response.subs   = activeSubscriptions;
            response.status = 'Success';
            response.message = 'These are the active subscriptions for the account.';
        }
    else {
            response.subs = null;
            response.status = 'Error';
            response.message = 'There are No active subscriptions for this account.';
        }

        return response;
    }

    global class SubscriptionsWrapper {
        public List<Subscription__c>   subs;
        public String   status;
        public String   message;

        public SubscriptionsWrapper(){}
    }
}
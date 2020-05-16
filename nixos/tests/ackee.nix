import ./make-test-python.nix ({ lib, ... } : {
  name = "ackee";
  meta = with lib.maintainers; {
    maintainers = [ Flakebi ];
  };

  machine = { ... }: {
    # For mongodb 4.2
    nixpkgs.config.allowUnfree = true;

    services.ackee = {
      enable = true;
      settings = {
        ACKEE_PASSWORD = "verysecretpassword";
      };
      environmentFile = "/dev/null";
    };
  };

  testScript = ''
    import json

    machine.wait_for_unit("ackee.service")
    machine.wait_until_succeeds("curl -fs localhost:3000")

    def graphql_request(query, data, auth = None):
        auth_header = " -H 'Authorization: Bearer " + auth + "'" if auth != None else ""

        response = json.loads(machine.succeed("curl localhost:3000/api -X POST -H 'content-type: application/json'"
            + auth_header
            + " --data '" + '{"variables":' + data + ', \
            "query":"' + query + '"}' + "'"))
        print("GraphQL response:", response)
        return response

    with subtest("Login"):
        response = graphql_request('mutation createToken($input: CreateTokenInput!) \
            { createToken(input: $input) { payload { id } } }',
            '{"input":{"username":"ackee","password":"verysecretpassword"}}')
        token = response["data"]["createToken"]["payload"]["id"]

    with subtest("Create domain"):
        response = graphql_request('mutation createDomain($input: CreateDomainInput!) \
            { createDomain(input: $input) { payload { id title } } }',
            '{"input":{"title":"My Domain"}}', token)
        domainId = response["data"]["createDomain"]["payload"]["id"]

    with subtest("Check that domain exists"):
        response = graphql_request('query getDomains \
            { domains { id title } }',
            '{}', token)
        domain = response["data"]["domains"][0]
        assert domain["id"] == domainId and domain["title"] == "My Domain"
  '';
})

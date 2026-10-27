{ lib, ... }:
{
  name = "papra";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  containers.machine = {
    services.papra = {
      enable = true;
      environment = {
        AUTH_IS_EMAIL_VERIFICATION_REQUIRED = false;
        AUTH_FIRST_USER_AS_ADMIN = true;
      };
    };
  };

  testScript =
    let
      serverBaseUrl = "http://localhost:1221";
      cookieJar = "/tmp/papra-cookies";

      jsonArg = value: "'${lib.escape [ "\"" "'" ] (builtins.toJSON value)}'";
    in
    ''
      import json

      machine.wait_for_unit("papra.service")
      machine.wait_for_open_port(1221)

      with subtest("Health endpoint responds"):
          machine.succeed("curl --fail --silent ${serverBaseUrl}/api/health")

      with subtest("Register a user"):
          machine.succeed(
              "curl --fail --silent"
              + " --cookie-jar ${cookieJar}"
              + " --json ${
                jsonArg {
                  email = "admin@example.com";
                  password = "correct horse battery staple";
                  name = "Admin";
                }
              }"
              + " ${serverBaseUrl}/api/auth/sign-up/email"
          )

      with subtest("Create an organization"):
          organization = json.loads(machine.succeed(
              "curl --fail --silent"
              + " --cookie ${cookieJar}"
              + " --json ${jsonArg { name = "Test Org"; }}"
              + " ${serverBaseUrl}/api/organizations"
          ))
          org_id = organization["organization"]["id"]
          assert org_id, f"Expected an organization id, got: {json.dumps(organization)}"

      with subtest("Import a document"):
          machine.succeed("echo 'hello from the nixos test' > /tmp/document.txt")
          document = json.loads(machine.succeed(
              "curl --fail --silent"
              + " --cookie ${cookieJar}"
              + " --form file=@/tmp/document.txt"
              + f" ${serverBaseUrl}/api/organizations/{org_id}/documents"
          ))
          document_id = document["document"]["id"]
          assert document_id, f"Expected a document id, got: {json.dumps(document)}"

      with subtest("Retrieve the imported document"):
          machine.succeed(
              "curl --fail --silent"
              + " --cookie ${cookieJar}"
              + f" ${serverBaseUrl}/api/organizations/{org_id}/documents/{document_id}/file"
              + " --output /tmp/retrieved-document.txt"
          )
          machine.succeed("diff /tmp/document.txt /tmp/retrieved-document.txt")
    '';
}

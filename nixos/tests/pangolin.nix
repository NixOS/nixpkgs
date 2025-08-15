{ lib, pkgs, ... }:
let
  domain = "example.test";
  # this API key matches the hash we insert into the database
  apiKey = "fbon8g22m7uf8q2.mwpnq3r5ul3h5w25fskwmkvqe4eysha54admqqci";
  subnet = "100.90.128.0/24";
  address = "100.90.128.0";
  pubKey = "this.is.the.public.key";
  newtId = "this.is.the.newt.id";
  secret = "1234567890";

  dbFilePath = "/var/lib/pangolin/config/db/db.sqlite";
  # API key values to be inserted
  # prefixed so that order is preserved by the attrNames ordering :)
  # also have to double escape for some stupid reason
  sqliteApiKeyVals = {
    a_apiKeyId = "fbon8g22m7uf8q2";
    aa_name = "nixos_test_root_key";
    aaa_apiKeyHash = "\$argon2id\$v=19\$m=19456,t=2,p=1\$P7UW7G2tKRyPBQrSrEtyDw\$8chVEPeCleRPGuX1I8xxdn73TW3HZ8EqEmqszy015Rg";
    aaaa_lastChars = "qqci";
    aaaaa_dateCreated = "2025-08-12T12:21:56.028Z";
    aaaaaa_isRoot = "1";
  };

  # lib.toGNUCommandLineShell
  # TODO use lib.escapeShellArg or write custom function to do this
  concatAttrsStringSep = sep: attrSet: (lib.concatMapAttrsStringSep sep (n: v: "'${v}'")) attrSet;

  headers =
    url: d:
    "curl "
    + lib.cli.toGNUCommandLineShell { } {
      X = "PUT";
      url = "http://localhost:3004/v1/${url}";
      H = [
        "Authorization: Bearer ${apiKey}"
        "Content-Type: application/json"
        "accept: */*"
      ];
      inherit d;
    };
  orgCreateCmd =
    headers "org"
    <| lib.escape [ "\"" ]
    <| builtins.toJSON
    <| {
      name = "test";
      orgId = "test";
      inherit subnet;
    };

  siteCreateCmd =
    headers "org/test/site"
    <| lib.escape [ "\"" ]
    <| builtins.toJSON
    <| {
      name = "test_site";
      exitNodeId = 1;
      type = "newt";
      inherit
        pubKey
        subnet
        newtId
        secret
        address
        ;
    };
in
rec {
  name = "pangolin";
  meta.maintainers = with lib.maintainers; [ jackr ];

  # stupid mulitline strings
  skipTypeCheck = true;
  skipLint = true;

  nodes = {

    VPS = {
      imports = [ ./common/acme/client ];
      networking.domain = domain;

      environment = {
        etc."nixos/secrets/pangolin.env".text = ''
          SERVER_SECRET=${secret}
        '';
        systemPackages = with pkgs; [
          fosrl-pangolin
          sqlite
          (writeScriptBin "create-db" ''
            ${lib.getExe sqlite} ${dbFilePath} <<'EOF'
            INSERT INTO apiKeys (apiKeyId, name, apiKeyHash, lastChars, dateCreated, isRoot)
            VALUES (${concatAttrsStringSep "," sqliteApiKeyVals});
            EOF
          '')
          (writeScriptBin "add-perms-db" ''
            ${lib.getExe sqlite} ${dbFilePath} <<'EOF'
            INSERT INTO apiKeyActions (apiKeyId, actionId)
            VALUES ${
              lib.concatMapStringsSep "," (p: "(\"fbon8g22m7uf8q2\", \"${p}\")") [
                "listOrgs"
                "checkOrgId"
                "createOrg"
                "deleteOrg"
                "listApiKeys"
                "listApiKeyActions"
                "setApiKeyActions"
                "createApiKey"
                "deleteApiKey"
                "getOrg"
                "updateOrg"
                "getOrgUser"
                "inviteUser"
                "removeUser"
                "listUsers"
                "listOrgDomains"
                "createSite"
                "deleteSite"
                "getSite"
                "listSites"
                "updateSite"
                "listSiteRoles"
                "createResource"
                "deleteResource"
                "getResource"
                "listResources"
                "updateResource"
                "listResourceUsers"
                "setResourceUsers"
                "setResourceRoles"
                "listResourceRoles"
                "setResourcePassword"
                "setResourcePincode"
                "setResourceWhitelist"
                "getResourceWhitelist"
                "createTarget"
                "deleteTarget"
                "getTarget"
                "listTargets"
                "updateTarget"
                "createRole"
                "deleteRole"
                "getRole"
                "listRoles"
                "updateRole"
                "listRoleResources"
                "addUserRole"
                "generateAccessToken"
                "deleteAcessToken"
                "listAccessTokens"
                "createResourceRule"
                "deleteResourceRule"
                "listResourceRules"
                "updateResourceRule"
                "createIdp"
                "updateIdp"
                "deleteIdp"
                "listIdps"
                "getIdp"
                "createIdpOrg"
                "deleteIdpOrg"
                "listIdpOrgs"
                "updateIdpOrg"
                "updateUser"
                "getUser"
              ]
            };
            EOF
          '')
        ];

      };
      services.pangolin = {
        enable = true;
        baseDomain = domain;
        letsEncryptEmail = "email@${domain}";
        openFirewall = true;
        pangolinEnvironmentFile = "/etc/nixos/secrets/pangolin.env";
        settings = {
          flags.enable_integration_api = true;
        };
      };
    };

    privateHost = {
      # TODO, check if this is correct.
      # API is unclear on what's what
      environment.etc."nixos/secrets/newt.env".text = ''
        NEWT_ID=${newtId}
        NEWT_SECRET=${secret}
      '';
      services.newt = {
        enable = true;
        endpoint = domain;
        environmentFile = "/etc/secrets/nixos/newt.env"; # TODO
      };
    };

    # Fake ACME server which will respond to client requests
    acme =
      { nodes, ... }:
      {
        imports = [ ./common/acme/server ];
      };
  };
  # general idea:
  # Panglin on the VPS, and Newt in the privateHost
  # setup ACME server to sign certificates and point
  # DNS to the correct machine
  testScript = ''
    # import pathlib
    # import os
    #
    VPS.start()
    # privateHost.start()

    with subtest("start pangolin"):
      VPS.wait_for_unit("pangolin.service")

    with subtest("create admin"):
      VPS.execute("pangctl set-admin-credentials --email \"admin@example.test\" --password \"Password123!\"")
      VPS.succeed("sqlite3 ${dbFilePath} '.tables' >> /tmp/dbres")

    with subtest("insert APIKEY"):
      VPS.wait_for_file("${dbFilePath}")
      VPS.succeed("create-db")
      VPS.succeed("sqlite3 ${dbFilePath} 'select * from apiKeys' >> /tmp/dbres")
      VPS.copy_from_vm("/tmp/dbres")

    with subtest("add APIKEY permissions"):
      VPS.log(VPS.succeed("add-perms-db"))
      VPS.succeed("sqlite3 ${dbFilePath} 'select * from apiKeyActions' >> /tmp/dbres")
      VPS.copy_from_vm("/tmp/dbres")

    with subtest("create org and site"):
      VPS.wait_for_open_port("3004")
      VPS.log(VPS.succeed("${orgCreateCmd}"))
      # t.AssertIn( ..., "success":true)
      VPS.log(VPS.succeed("${siteCreateCmd}"))
      # t.AssertIn( ..., "success":true)
      VPS.succeed("sqlite3 ${dbFilePath} 'select * from userOrgs' >> /tmp/dbres")
      VPS.succeed("sqlite3 ${dbFilePath} 'select * from userSites' >> /tmp/dbres")

    # TODO
    # with subtest("check org exists"):
      # VPS.succeed("curl -X 'GET' 'https://pangolin.${nodes.VPS.services.pangolin.baseDomain}/v1/orgs?limit=1000&offset=0' -H 'accept: */*' -H 'Authorization: Bearer ${apiKey}'")
  '';
}

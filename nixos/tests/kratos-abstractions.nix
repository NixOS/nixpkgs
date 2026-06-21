{ lib, pkgs, ... }:

{
  name = "kratos-abstractions";
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  nodes.machine =
    { ... }:
    let
      identitySchema = pkgs.writeText "kratos-identity.schema.json" ''
        {
          "$id": "https://example.com/schemas/identity.schema.json",
          "$schema": "http://json-schema.org/draft-07/schema#",
          "title": "Identity",
          "type": "object",
          "properties": {
            "traits": {
              "type": "object",
              "properties": {
                "email": {
                  "type": "string",
                  "format": "email",
                  "ory.sh/kratos": {
                    "credentials": {
                      "password": {
                        "identifier": true
                      }
                    }
                  }
                }
              },
              "required": [ "email" ],
              "additionalProperties": false
            }
          }
        }
      '';

      defaultSecret = pkgs.writeText "kratos-default-secret" "abcdefghijklmnopqrstuvwxyz123456";
      cookieSecret = pkgs.writeText "kratos-cookie-secret" "bcdefghijklmnopqrstuvwxyz1234567";
      cipherSecret = pkgs.writeText "kratos-cipher-secret" "0123456789abcdef0123456789abcdef";
      smtpConnectionURI = pkgs.writeText "kratos-smtp-connection-uri" "smtps://test:test@localhost:1025/?skip_ssl_verify=true";
    in
    {
      services.kratos = {
        enable = true;
        database.createLocally = true;
        identitySchemas = [
          {
            id = "default";
            path = identitySchema;
          }
        ];
        urls = {
          public = "https://id.example.test/";
          admin = "http://kratos.internal.test:4434/";
          selfService = "https://auth.example.test";
          defaultReturnTo = "https://app.example.test/";
          allowedReturnUrls = [
            "https://app.example.test/"
            "https://auth.example.test/"
          ];
        };
        secretFiles = {
          default = [ defaultSecret ];
          cookie = [ cookieSecret ];
          cipher = [ cipherSecret ];
          courierSmtpConnectionURI = smtpConnectionURI;
        };
        settings = {
          selfservice.methods.password.enabled = true;
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      settings = nodes.machine.services.kratos.settings;
    in
    ''
      machine.wait_for_unit("postgresql.service")
      machine.wait_for_unit("kratos-postgresql-init.service")
      machine.wait_for_unit("kratos-migrate.service")
      machine.wait_for_unit("kratos.service")
      machine.wait_for_open_port(4433)
      machine.wait_for_open_port(4434)

      machine.succeed("curl --fail http://127.0.0.1:4433/health/ready")
      machine.succeed("curl --fail http://127.0.0.1:4434/health/ready")
      machine.succeed("su - postgres -c \"psql -tAc \\\"SELECT 1 FROM pg_database WHERE datname = 'kratos'\\\"\" | grep 1")

      assert "${settings.serve.public.base_url}" == "https://id.example.test/"
      assert "${settings.serve.admin.base_url}" == "http://kratos.internal.test:4434/"
      assert "${settings.selfservice.default_browser_return_url}" == "https://app.example.test/"
      assert "${settings.selfservice.flows.login.ui_url}" == "https://auth.example.test/login"
      assert "${settings.selfservice.flows.registration.ui_url}" == "https://auth.example.test/registration"
      assert "${settings.selfservice.flows.settings.ui_url}" == "https://auth.example.test/settings"
      assert "${settings.selfservice.flows.error.ui_url}" == "https://auth.example.test/error"
      assert "${settings.selfservice.flows.recovery.ui_url}" == "https://auth.example.test/recovery"
      assert "${settings.selfservice.flows.verification.ui_url}" == "https://auth.example.test/verification"
      assert "${settings.selfservice.flows.logout.after.default_browser_return_url}" == "https://auth.example.test/login"
    '';
}

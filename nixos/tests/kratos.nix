{ lib, ... }:

{
  name = "kratos";
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  nodes.machine =
    { config, ... }:
    let
      identitySchema = config.node.pkgs.writeText "kratos-identity.schema.json" ''
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
                    },
                    "recovery": {
                      "via": "email"
                    },
                    "verification": {
                      "via": "email"
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
    in
    {
      services.kratos = {
        enable = true;
        identitySchemas = [
          {
            id = "default";
            path = identitySchema;
          }
        ];
        settings = {
          selfservice = {
            default_browser_return_url = "http://127.0.0.1:4455/";
            allowed_return_urls = [ "http://127.0.0.1:4455/" ];
            methods.password.enabled = true;
            flows = {
              error.ui_url = "http://127.0.0.1:4455/error";
              settings = {
                ui_url = "http://127.0.0.1:4455/settings";
                privileged_session_max_age = "15m";
              };
              recovery = {
                enabled = true;
                ui_url = "http://127.0.0.1:4455/recovery";
              };
              verification = {
                enabled = true;
                ui_url = "http://127.0.0.1:4455/verification";
              };
              logout.after.default_browser_return_url = "http://127.0.0.1:4455/login";
              login = {
                ui_url = "http://127.0.0.1:4455/login";
                lifespan = "10m";
              };
              registration = {
                ui_url = "http://127.0.0.1:4455/registration";
                lifespan = "10m";
                after.password.hooks = [ { hook = "session"; } ];
              };
            };
          };
          secrets = {
            cookie = [ "abcdefghijklmnopqrstuvwxyz123456" ];
            cipher = [ "0123456789abcdef0123456789abcdef" ];
            default = [ "abcdefghijklmnopqrstuvwxyz123456" ];
          };
          courier.smtp.connection_uri = "smtps://test:test@localhost:1025/?skip_ssl_verify=true";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("kratos-migrate.service")
    machine.wait_for_unit("kratos.service")
    machine.wait_for_open_port(4433)
    machine.wait_for_open_port(4434)

    machine.succeed("curl --fail http://127.0.0.1:4433/health/ready")
    machine.succeed("curl --fail http://127.0.0.1:4434/health/ready")
    machine.succeed("test -f /var/lib/kratos/db.sqlite")
  '';
}

{ ... }:
{
  name = "authentik-nixos";

  nodes.machine =
    { lib, pkgs, ... }:
    let
      secretsFile = pkgs.writeText "authentik-secret-env" ''
        VERY_SENSITIVE_SECRET
      '';
    in
    {
      # These tests need a little more juice
      virtualisation = {
        cores = 2;
        memorySize = 2048;
      };

      environment.systemPackages = [
        pkgs.jq
        pkgs.openldap
      ];

      services.authentik = {
        enable = true;
        secretFiles = {
          AUTHENTIK_SECRET_KEY = toString secretsFile;
        };
        outposts.ldap = {
          enable = true;
          environment = {
            AUTHENTIK_HOST = "http://localhost:9000";
            AUTHENTIK_INSECURE = "true";
          };
          secretFiles.AUTHENTIK_TOKEN = "/var/lib/authentik/token";
        };
        environment = {
          AUTHENTIK_BOOTSTRAP_PASSWORD = "admin";
          AUTHENTIK_BOOTSTRAP_TOKEN = "mysecrettoken";
          AUTHENTIK_BOOTSTRAP_EMAIL = "admin@example.com";
        };
      };

      systemd.services.authentik-ldap-outpost = {
        wantedBy = lib.mkForce [ ];
        serviceConfig.RuntimeDirectory = "authentik";
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("authentik-server.service")
    machine.wait_for_unit("authentik-worker.service")

    machine.wait_for_open_port(9000)

    getcmd = "curl -s -H 'Authorization: Bearer mysecrettoken' -H 'Accept: application/json' "
    postcmd = getcmd + "-H 'Content-Type: application/json' -X POST "

    def get_flow(slug):
      return json.loads(machine.wait_until_succeeds(getcmd + "http://localhost:9000/api/v3/flows/instances/ | jq -e '.results.[] | select(.slug == \"" + slug + "\")'", timeout=30*60))

    auth_flow = get_flow("default-authentication-flow")
    invalid_flow = get_flow("default-invalidation-flow")

    data = {
      'name': 'ldap',
      'authorization_flow': auth_flow['pk'],
      'invalidation_flow': invalid_flow['pk']
    }
    ldap_provider = json.loads(machine.succeed(postcmd + "--data '" + json.dumps(data) + "' http://localhost:9000/api/v3/providers/ldap/"))

    data = {
      'name': 'ldap',
      'slug': 'ldap',
      'provider': ldap_provider['pk']
    }
    machine.succeed(postcmd + "--data '" + json.dumps(data) + "' http://localhost:9000/api/v3/core/applications/")

    data = {
      'name': 'ldap',
      'type': 'ldap',
      'providers': [ldap_provider['pk']],
      'config': {}
    }
    ldap_outpost = json.loads(machine.succeed(postcmd + "--data '" + json.dumps(data) + "' http://localhost:9000/api/v3/outposts/instances/"))

    ldap_token = json.loads(machine.succeed(getcmd + " http://localhost:9000/api/v3/core/tokens/" + ldap_outpost['token_identifier'] + "/view_key/"))['key']

    machine.succeed("mkdir -p /var/lib/authentik")
    machine.succeed("echo '" + ldap_token + "' > /var/lib/authentik/token")

    machine.systemctl("start authentik-ldap-outpost")
    machine.wait_for_open_port(3389)

    machine.succeed("ldapsearch -x -H ldap://localhost:3389 -D 'cn=akadmin,ou=users,dc=ldap,dc=goauthentik,dc=io' -w admin -b 'dc=ldap,dc=goauthentik,dc=io' '(objectClass=user)'")
  '';
}

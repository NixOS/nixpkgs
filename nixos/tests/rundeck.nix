import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "rundeck";

    nodes = {
      server =
        { config, pkgs, ... }:
        {
          imports = [
            ./rundeck.nix
          ];

          networking.firewall.allowedTCPPorts = [ 4440 ];

          services.rundeck = {
            enable = true;
            serverHostname = "server";
            adminUser = "testadmin";
            adminPassword = "testpassword";

            aclPolicies = {
              "admin.aclpolicy" = ''
                description: Admin ACL for tests
                context:
                  project: '.*'
                for:
                  resource:
                    - allow: '*'
                  job:
                    - allow: '*'
                  node:
                    - allow: '*'
                by:
                  group: admin
                ---
                description: Admin ACL in application scope
                context:
                  application: 'rundeck'
                for:
                  resource:
                    - allow: '*'
                  project:
                    - allow: '*'
                by:
                  group: admin
              '';
            };

            database = {
              type = "h2";
            };
          };

          virtualisation.memorySize = 2048;
          virtualisation.diskSize = 4096;
        };

      client =
        { config, pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            curl
            jq
          ];
        };
    };

    testScript = ''
      import time

      start_all()

      server.wait_for_unit("rundeck.service")
      server.succeed("systemctl status rundeck.service")

      server.succeed("test -d /var/lib/rundeck")
      server.succeed("test -d /etc/rundeck")
      server.succeed("test -d /var/lib/rundeck/projects")

      server.succeed("test -f /etc/rundeck/rundeck-config.properties")
      server.succeed("test -f /etc/rundeck/framework.properties")
      server.succeed("test -f /etc/rundeck/realm.properties")

      server.wait_until_succeeds("curl -s http://server:4440 | grep -q Rundeck")

      server.succeed("getent passwd rundeck")
      server.succeed("getent group rundeck")

      server.succeed("stat -c '%U:%G' /var/lib/rundeck | grep -q 'rundeck:rundeck'")

      server.succeed("test -f /var/lib/rundeck/.ssh/id_rsa")
      server.succeed("test -f /var/lib/rundeck/.ssh/id_rsa.pub")

      server.wait_until_succeeds(
          "curl -s -L -u testadmin:testpassword http://server:4440/api/26/system/info | grep -q 'rundeck.version'"
      )

      server.succeed(
          "curl -s -L -X POST -u testadmin:testpassword" +
          " -H 'Content-Type: application/json'" +
          " -d '{\"name\":\"test-project\",\"config\":{}}'" +
          " http://server:4440/api/26/projects"
      )

      server.succeed(
          "curl -s -L -u testadmin:testpassword http://server:4440/api/26/projects | grep -q 'test-project'"
      )

      client.wait_until_succeeds(
          "curl -s http://server:4440 | grep -q Rundeck"
      )

      client.succeed(
          "curl -s -L -u testadmin:testpassword http://server:4440/api/26/system/info | jq -e '.system.rundeck.version'"
      )

      server.succeed("systemctl stop rundeck.service")
      server.wait_for_unit("rundeck.service", "inactive")
    '';
  }
)

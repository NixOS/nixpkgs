{
  name = "rundeck";

  nodes = {
    defaultConf =
      { pkgs, ... }:
      {
        services.rundeck = {
          enable = true;
          serverHostname = "defaultConf";
          adminUser = "admin";
          adminPassword = "password";
          database.type = "h2";
        };
        services.rundeck.openFirewall = true;
        environment.systemPackages = with pkgs; [
          curl
          jq
        ];
      };

    customConf =
      { pkgs, ... }:
      {
        services.rundeck = {
          enable = true;
          serverHostname = "customConf";
          adminUser = "testadmin";
          adminPassword = "testpassword";
          serverPort = 4441;
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

        services.rundeck.openFirewall = true;
        environment.systemPackages = with pkgs; [
          curl
          jq
        ];
        virtualisation.memorySize = 2048;
        virtualisation.diskSize = 4096;
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          curl
          jq
        ];
      };
  };

  testScript = ''
    start_all()

    with subtest("Basic configuration test"):
      defaultConf.wait_for_unit("rundeck.service")
      defaultConf.wait_for_open_port(4440)
      defaultConf.wait_until_succeeds("curl -s http://defaultConf:4440 | grep -q Rundeck")
      defaultConf.wait_until_succeeds(
          "curl -s -L -u admin:password http://defaultConf:4440/api/26/system/info | grep -q 'rundeck.version'"
      )

    with subtest("Custom configuration test"):
      customConf.wait_for_unit("rundeck.service")
      customConf.wait_for_open_port(4441)

      customConf.wait_until_succeeds("curl -s http://customConf:4441 | grep -q Rundeck")

      customConf.wait_until_succeeds(
          "curl -s -L -u testadmin:testpassword http://customConf:4441/api/26/system/info | grep -q 'rundeck.version'"
      )

      customConf.succeed(
          "curl -s -L -X POST -u testadmin:testpassword" +
          " -H 'Content-Type: application/json'" +
          " -d '{\"name\":\"test-project\",\"config\":{}}'" +
          " http://customConf:4441/api/26/projects"
      )

      customConf.succeed(
          "curl -s -L -u testadmin:testpassword http://customConf:4441/api/26/projects | grep -q 'test-project'"
      )

    with subtest("Remote access test"):
      client.wait_until_succeeds(
          "curl -s http://customConf:4441 | grep -q Rundeck"
      )

      client.succeed(
          "curl -s -L -u testadmin:testpassword http://customConf:4441/api/26/system/info | jq -e '.system.rundeck.version'"
      )
  '';
}

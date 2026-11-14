{
  name = "rundeck";

  nodes = {
    rundeck =
      { pkgs, ... }:
      {
        environment.etc."rundeck-admin-password" = {
          text = "testpassword";
          mode = "0400";
          user = "rundeck";
          group = "rundeck";
        };

        environment.etc."rundeck-tokens.properties" = {
          text = "testadmin: nixostesttoken,admin";
          mode = "0400";
          user = "rundeck";
          group = "rundeck";
        };

        services.rundeck = {
          enable = true;
          serverHostname = "rundeck";
          adminUser = "testadmin";
          adminPasswordFile = "/etc/rundeck-admin-password";
          serverPort = 4441;
          database.type = "h2";
          openFirewall = true;
          frameworkSettings."rundeck.tokens.file" = "/etc/rundeck-tokens.properties";
        };

        environment.systemPackages = with pkgs; [
          curl
          jq
        ];
      };
  };

  testScript = ''
    start_all()

    api = "http://rundeck:4441/api/26"
    token = "-H 'X-Rundeck-Auth-Token: nixostesttoken' -H 'Accept: application/json'"

    def properties(machine, path):
        return machine.succeed(f"cat {path}").replace("\\", "").replace(" = ", "=")

    with subtest("Rundeck starts and serves homepage"):
        rundeck.wait_for_unit("rundeck.service")
        rundeck.wait_for_open_port(4441)
        rundeck.wait_until_succeeds(
            "curl -sL http://rundeck:4441 | grep -qi Rundeck"
        )

    with subtest("Regression - port is included in generated URLs"):
        config = properties(rundeck, "/etc/rundeck/rundeck-config.properties")
        framework = properties(rundeck, "/etc/rundeck/framework.properties")

        assert "grails.serverURL=http://rundeck:4441" in config, config
        assert "server.port=4441" in config, config
        assert "framework.server.url=http://rundeck:4441" in framework, framework

    with subtest("Structural settings end up in the generated config"):
        config = properties(rundeck, "/etc/rundeck/rundeck-config.properties")

        assert "dataSource.driverClassName=org.h2.Driver" in config, config
        assert "dataSource.dialect=org.hibernate.dialect.H2Dialect" in config, config

    with subtest("Server UUID is generated and substituted"):
        framework = properties(rundeck, "/etc/rundeck/framework.properties")

        assert "@SERVER_UUID@" not in framework, framework
        rundeck.succeed(
            "grep -qE '^rundeck\\.server\\.uuid = [0-9a-f-]{36}$'"
            " /etc/rundeck/framework.properties"
        )

    with subtest("Secrets are substituted and not world-readable"):
        rundeck.succeed(
            "grep -qxF 'testadmin:testpassword,user,admin'"
            " /etc/rundeck/realm.properties"
        )
        rundeck.fail("grep -q '@ADMIN_PASSWORD@' /etc/rundeck/realm.properties")
        rundeck.succeed(
            "[ \"$(stat -c %a /etc/rundeck/realm.properties)\" = 600 ]"
        )
        rundeck.succeed(
            "[ \"$(stat -c %U /etc/rundeck/realm.properties)\" = rundeck ]"
        )

    with subtest("Form login accepts realm credentials"):
        rundeck.wait_until_succeeds(
            "curl -s -o /dev/null -w '%{url_effective}' -c /tmp/login-cookies -L"
            " -d 'j_username=testadmin&j_password=testpassword'"
            " http://rundeck:4441/j_security_check"
            " | grep -qvE 'error|login'",
            timeout=300,
        )

    with subtest("API authentication via static token"):
        rundeck.wait_until_succeeds(
            f"curl -s {token} {api}/system/info"
            " | jq -e '.system.rundeck.version'",
            timeout=300,
        )

        rundeck.succeed(
            f"curl -s {token} -X POST"
            " -H 'Content-Type: application/json'"
            " -d '{\"name\":\"test-project\",\"config\":{}}'"
            f" {api}/projects"
            " | jq -e '.name == \"test-project\"'"
        )

        rundeck.succeed(
            f"curl -s {token} {api}/projects"
            " | jq -e 'any(.[]; .name == \"test-project\")'"
        )
  '';
}

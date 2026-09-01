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

        services.rundeck = {
          enable = true;
          serverHostname = "rundeck";
          adminUser = "testadmin";
          adminPasswordFile = "/etc/rundeck-admin-password";
          serverPort = 4441;
          database.type = "h2";
          openFirewall = true;
        };

        environment.systemPackages = with pkgs; [
          curl
          jq
        ];
      };
  };

  testScript = ''
    start_all()

    def login_and_verify_api(machine, host, port, user, password, timeout=300):
        """Authenticate via Rundeck form login and verify API access."""
        machine.wait_until_succeeds(
            f"curl -s -c /tmp/cookies -L"
            f" -d 'j_username={user}&j_password={password}'"
            f" http://{host}:{port}/j_security_check -o /dev/null"
            f" && curl -s -b /tmp/cookies -H 'Accept: application/json'"
            f" http://{host}:{port}/api/26/system/info"
            f" | jq -e '.system.rundeck.version'",
            timeout=timeout,
        )

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

    with subtest("API authentication via form login"):
        login_and_verify_api(rundeck, "rundeck", 4441, "testadmin", "testpassword")

        rundeck.succeed(
            "curl -s -b /tmp/cookies -X POST"
            " -H 'Accept: application/json'"
            " -H 'Content-Type: application/json'"
            " -d '{\"name\":\"test-project\",\"config\":{}}'"
            " http://rundeck:4441/api/26/projects"
            " | jq -e '.name == \"test-project\"'"
        )

        rundeck.succeed(
            "curl -s -b /tmp/cookies -H 'Accept: application/json'"
            " http://rundeck:4441/api/26/projects"
            " | jq -e 'any(.[]; .name == \"test-project\")'"
        )
  '';
}

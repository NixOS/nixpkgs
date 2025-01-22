{
  name = "rundeck";

  nodes = {
    rundeck =
      { pkgs, ... }:
      {
        services.rundeck = {
          enable = true;
          serverHostname = "rundeck";
          adminUser = "testadmin";
          adminPassword = "testpassword";
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

    with subtest("Rundeck starts and serves homepage"):
        rundeck.wait_for_unit("rundeck.service")
        rundeck.wait_for_open_port(4441)
        rundeck.wait_until_succeeds(
            "curl -s http://rundeck:4441 | grep -q Rundeck"
        )

    with subtest("Regression - port is included in generated URLs"):
        rundeck.succeed(
            "grep -qE '^grails\\.serverURL=http://rundeck:4441$'"
            " /etc/rundeck/rundeck-config.properties"
        )

        rundeck.succeed(
            "grep -qE '^framework\\.server\\.url = http://rundeck:4441$'"
            " /etc/rundeck/framework.properties"
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

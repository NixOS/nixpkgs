{
  pkgs,
  lib,
  ...
}:
{
  name = "rustical";

  meta.maintainers = pkgs.rustical.meta.maintainers;

  nodes.machine =
    {
      pkgs,
      ...
    }:
    {
      services.rustical.enable = true;
      environment.systemPackages = with pkgs; [ calendar-cli ];
    };

  testScript =
    {
      nodes,
      ...
    }:
    let
      port = toString nodes.machine.services.rustical.settings.http.port;
      url = "http://localhost:${toString port}";

      createPrincipalScript = pkgs.writeScript "rustical-create-principal" ''
        #!${lib.getExe pkgs.expect}
        spawn rustical principals create alice --password
        expect "Enter your password:\r"
        send "foobar\r"
        expect eof
      '';

      calendarCliConfig = (pkgs.formats.json { }).generate "rustical-test-calendar-cli.json" {
        default = {
          caldav_user = "alice";
          caldav_url = "${url}/caldav/";
          calendar_url = "${url}/caldav/principal/alice";
        };
        testcal = {
          inherits = "default";
          calendar_url = "${url}/caldav/principal/alice/testcal";
        };
      };
    in
    # python
    ''
      machine.wait_for_unit("rustical.service")
      machine.wait_for_open_port(${port})

      with subtest("Smoketest"):
        machine.succeed("curl --fail ${url}")

      with subtest("Create principal"):
        machine.succeed("${createPrincipalScript}")
        machine.succeed("rustical principals list | grep alice")

      with subtest("Generate token for principal"):
        machine.succeed("curl -f -c cookies.txt -d 'username=alice&password=foobar' ${url}/frontend/login")
        machine.succeed("curl -f -b cookies.txt -d 'name=mytoken' ${url}/frontend/user/alice/app_token > token.txt")

      with subtest("Interact with caldav"):
        machine.succeed('calendar-cli --config-file ${calendarCliConfig} --caldav-pass "$(cat token.txt)" calendar create testcal')
        machine.succeed('calendar-cli --config-file ${calendarCliConfig} --config-section testcal --caldav-pass "$(cat token.txt)" calendar add 2013-10-01 testevent')

      machine.log(machine.execute("systemd-analyze security rustical.service | grep -v ✓")[1])
    '';
}

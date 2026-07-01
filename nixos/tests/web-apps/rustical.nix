{
  pkgs,
  lib,
  ...
}:

{
  name = "rustical";

  meta.maintainers = pkgs.rustical.meta.maintainers;

  containers.machine =
    {
      config,
      pkgs,
      ...
    }:
    {
      services.rustical.enable = true;
      services.nginx = {
        enable = true;
        virtualHosts."localhost" = {
          locations."/" = {
            proxyPass = "http://${config.services.rustical.settings.http.bind}";
          };
        };
      };
      systemd.services.nginx.serviceConfig.SupplementaryGroups = [ "rustical" ];
      environment.systemPackages = with pkgs; [ calendar-cli ];
    };

  testScript =
    {
      containers,
      ...
    }:
    let
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
          caldav_url = "http://localhost/caldav/";
          calendar_url = "http://localhost/caldav/principal/alice";
        };
        testcal = {
          inherits = "default";
          calendar_url = "http://localhost/caldav/principal/alice/testcal";
        };
      };
    in
    # python
    ''
      machine.wait_for_unit("rustical.service")
      machine.wait_for_file("${lib.removePrefix "unix:" containers.machine.services.rustical.settings.http.bind}")
      machine.wait_for_open_port(80)

      with subtest("Smoketest"):
        machine.succeed("curl --fail http://localhost")

      with subtest("Create principal"):
        machine.succeed("${createPrincipalScript}")
        machine.succeed("rustical principals list | grep alice")

      with subtest("Generate token for principal"):
        machine.succeed("curl -f -c cookies.txt -d 'username=alice&password=foobar' http://localhost/frontend/login")
        machine.succeed("curl -f -b cookies.txt -d 'name=mytoken' http://localhost/frontend/user/alice/app_token > token.txt")

      with subtest("Interact with caldav"):
        machine.succeed('calendar-cli --config-file ${calendarCliConfig} --caldav-pass "$(cat token.txt)" calendar create testcal')
        machine.succeed('calendar-cli --config-file ${calendarCliConfig} --config-section testcal --caldav-pass "$(cat token.txt)" calendar add 2013-10-01 testevent')

      machine.log(machine.execute("systemd-analyze security rustical.service | grep -v ✓")[1])
    '';
}

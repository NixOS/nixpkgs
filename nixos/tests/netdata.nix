# This test runs netdata and checks for data via apps.plugin

{ pkgs, ... }:
{
  name = "netdata";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      cransom
      raitobezarius
    ];
  };

  nodes = {
    netdata =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          curl
          jq
          netdata
        ];
        services.netdata = {
          enable = true;
          package = pkgs.netdataCloud;
          python.recommendedPythonPackages = true;

          configDir."apps_groups.conf" = pkgs.writeText "apps_groups.conf" ''
            netdata_test: netdata
          '';
        };
      };
  };

  testScript = ''
    start_all()

    netdata.wait_for_unit("netdata.service")

    # wait for the service to listen before sending a request
    netdata.wait_for_open_port(19999)

    # check if the netdata main page loads.
    netdata.succeed("curl --fail http://127.0.0.1:19999")
    netdata.succeed("sleep 4")

    # check if netdata api shows correct os
    url = "http://127.0.0.1:19999/api/v3/info"
    filter = '.agents[0].application.os.os | . == "NixOS"'
    cmd = f"curl -s {url} | jq -e '{filter}'"
    netdata.wait_until_succeeds(cmd)

    # check if the control socket is available
    netdata.succeed("sudo netdatacli ping")
  '';
}

# This test runs netdata and checks for data via apps.plugin

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "netdata";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ cransom raitobezarius ];
  };

  nodes = {
    netdata =
      { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [ curl jq netdata ];
          services.netdata.enable = true;
        };
    };

  testScript = ''
    start_all()

    netdata.wait_for_unit("netdata.service")

    # wait for the service to listen before sending a request
    netdata.wait_for_open_port(19999)

    # check if the netdata main page loads.
    netdata.succeed("curl --fail http://localhost:19999/")
    netdata.succeed("sleep 4")

    # check if netdata can read disk ops for root owned processes.
    # if > 0, successful. verifies both netdata working and
    # apps.plugin has elevated capabilities.
    url = "http://localhost:19999/api/v1/data\?chart=user.root_disk_physical_io"
    filter = '[.data[range(10)][2]] | add | . < 0'
    cmd = f"curl -s {url} | jq -e '{filter}'"
    netdata.wait_until_succeeds(cmd)

    # check if the control socket is available
    netdata.succeed("sudo netdatacli ping")
  '';
})

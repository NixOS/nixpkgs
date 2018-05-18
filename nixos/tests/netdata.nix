# This test runs netdata and checks for data via apps.plugin

import ./make-test.nix ({ pkgs, ...} : {
  name = "netdata";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ cransom ];
  };

  nodes = {
    netdata =
      { config, pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [ curl jq ];
          services.netdata.enable = true;
        };
    };

  testScript = ''
    startAll;

    $netdata->waitForUnit("netdata.service");
    # check if netdata can read disk ops for root owned processes. 
    # if > 0, successful. verifies both netdata working and 
    # apps.plugin has elevated capabilities.
    my $cmd = <<'CMD';
    curl -s http://localhost:19999/api/v1/data\?chart=users.pwrites | \
       jq -e '[.data[range(10)][.labels | indices("root")[0]]] | add | . > 0'
    CMD
    $netdata->waitUntilSucceeds($cmd);
  '';
})

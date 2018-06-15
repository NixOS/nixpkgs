# This test runs basic munin setup with node and cron job running on the same
# machine.

import ./make-test.nix ({ pkgs, ...} : {
  name = "munin";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ domenkozar eelco chaoflow ];
  };

  nodes = {
    one =
      { config, pkgs, ... }:
        {
          services = {
           munin-node.enable = true;
           munin-cron = {
             enable = true;
             hosts = ''
               [${config.networking.hostName}]
               address localhost
             '';
           };
          };
          systemd.services.munin-node.serviceConfig.TimeoutStartSec = "3min";
        };
    };

  testScript = ''
    startAll;

    $one->waitForUnit("munin-node.service");
    $one->succeed('systemctl start munin-cron');
    $one->waitForFile("/var/lib/munin/one/one-uptime-uptime-g.rrd");
    $one->waitForFile("/var/www/munin/one/index.html");
  '';
})

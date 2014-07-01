# This test runs basic munin setup with node and cron job running on the same
# machine.

import ./make-test.nix {
  name = "munin";

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
        };
    };

  testScript = ''
    startAll;

    $one->waitForUnit("munin-node.service");
    $one->waitForFile("/var/lib/munin/one/one-uptime-uptime-g.rrd");
    $one->waitForFile("/var/www/munin/one/index.html");
  '';
}

# This test runs basic munin setup with node and cron job running on the same
# machine.

import ./make-test.nix ({ pkgs, ...} : {
  name = "munin";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ domenkozar eelco ];
  };

  nodes = {
    one =
      { config, ... }:
        {
          services = {
           munin-node = {
             enable = true;
             # disable a failing plugin to prevent irrelevant error message, see #23049
             disabledPlugins = [ "apc_nis" ];
           };
           munin-cron = {
            enable = true;
            hosts = ''
              [${config.networking.hostName}]
              address localhost
            '';
           };
          };
          # long timeout to prevent hydra failure on high load
          systemd.services.munin-node.serviceConfig.TimeoutStartSec = "10min";
        };
    };

  testScript = ''
    startAll;

    $one->waitForUnit("munin-node.service");
    # make sure the node is actually listening
    $one->waitForOpenPort(4949);
    $one->succeed('systemctl start munin-cron');
    # wait for munin-cron output
    $one->waitForFile("/var/lib/munin/one/one-uptime-uptime-g.rrd");
    $one->waitForFile("/var/www/munin/one/index.html");
  '';
})

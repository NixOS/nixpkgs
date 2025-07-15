# This test runs basic munin setup with node and cron job running on the same
# machine.

{ pkgs, ... }:
{
  name = "munin";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
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

        # increase the systemd timer interval so it fires more often
        systemd.timers.munin-cron.timerConfig.OnCalendar = pkgs.lib.mkForce "*:*:0/10";
      };
  };

  testScript = ''
    start_all()

    with subtest("ensure munin-node starts and listens on 4949"):
        one.wait_for_unit("munin-node.service")
        one.wait_for_open_port(4949)

    with subtest("ensure munin-cron output is correct"):
        one.wait_for_file("/var/lib/munin/one/one-uptime-uptime-g.rrd")
        one.wait_for_file("/var/www/munin/one/index.html")
        one.wait_for_file("/var/www/munin/one/one/diskstat_iops_vda-day.png", timeout=60)
  '';
}

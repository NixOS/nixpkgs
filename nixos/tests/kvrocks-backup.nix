{ lib, pkgs, ... }:

let
  common = {
    services.kvrocks = {
      enable = true;
      settings.log-level = "debug";
      backup.enable = true;
    };
  };
in
{
  name = "kvrocks-backup";
  meta.maintainers = with lib.maintainers; [ xyenon ];

  containers = {
    tcp = common;

    custom = {
      imports = [ common ];
      services.kvrocks.backup.location = "/srv/kvrocks-backups";
    };

    unix = {
      imports = [ common ];
      services.kvrocks.settings = {
        bind = [ ];
        unixsocket = "/run/kvrocks/kvrocks.sock";
      };
    };
  };

  testScript =
    { containers, ... }:
    let
      inherit (containers.tcp.services) kvrocks;
      port = toString kvrocks.settings.port;
      redisCli = lib.getExe' pkgs.redis "redis-cli";
      redisCliTcp = "${redisCli} -p ${port}";
      unixsocket = "/run/kvrocks/kvrocks.sock";
      redisCliUnix = "${redisCli} -s ${unixsocket}";
      backupDir = kvrocks.backup.location;
    in
    ''
      def restore_from_backup(node, cli, backup_dir, expected, wait_ready):
          node.succeed(f"{cli} set backup-key overwritten | grep OK")
          node.systemctl("stop kvrocks")
          node.succeed("rm -rf /var/lib/kvrocks/db")
          node.succeed(f"cp -a {backup_dir}/current /var/lib/kvrocks/db")
          node.systemctl("start kvrocks")
          node.wait_for_unit("kvrocks.service")
          wait_ready()
          node.succeed(f"{cli} get backup-key | grep {expected}")

      tcp.start()
      tcp.wait_for_unit("kvrocks.service")
      tcp.wait_for_open_port(${port})
      tcp.succeed("${redisCliTcp} ping | grep PONG")

      with subtest("Test backup over TCP"):
          tcp.succeed("${redisCliTcp} set backup-key tcp | grep OK")
          tcp.systemctl("start kvrocks-backup.service")
          tcp.succeed("test -f ${backupDir}/current/CURRENT")
          restore_from_backup(tcp, "${redisCliTcp}", "${backupDir}", "tcp", lambda: tcp.wait_for_open_port(${port}))
          tcp.shutdown()

      with subtest("Test backup with non-default backup location"):
          custom.start()
          custom.wait_for_unit("kvrocks.service")
          custom.wait_for_open_port(${port})
          custom.succeed("${redisCliTcp} set backup-key custom | grep OK")
          custom.systemctl("start kvrocks-backup.service")
          custom.succeed("test -f /srv/kvrocks-backups/current/CURRENT")
          restore_from_backup(custom, "${redisCliTcp}", "/srv/kvrocks-backups", "custom", lambda: custom.wait_for_open_port(${port}))
          custom.shutdown()

      with subtest("Test backup over unix socket"):
          unix.start()
          unix.wait_for_unit("kvrocks.service")
          unix.wait_for_file("${unixsocket}")
          unix.fail("${redisCliTcp} ping")
          unix.succeed("${redisCliUnix} set backup-key unix | grep OK")
          unix.systemctl("start kvrocks-backup.service")
          unix.succeed("test -f ${backupDir}/current/CURRENT")
          restore_from_backup(unix, "${redisCliUnix}", "${backupDir}", "unix", lambda: unix.wait_for_file("${unixsocket}"))
    '';
}

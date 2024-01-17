{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.clickhouse;
in
{

  ###### interface

  options = {

    services.clickhouse = {

      enable = lib.mkEnableOption "ClickHouse database server";

      package = lib.mkPackageOption pkgs "clickhouse" { };

      usersXml = lib.mkOption {
        type = lib.types.path;
        description = ''
          ClickHouse server users.xml override for
          declaring user access permissions and privileges
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.clickhouse.usersXml = lib.mkDefault (cfg.package + "/etc/clickhouse-server/users.xml");

    users.users.clickhouse = {
      name = "clickhouse";
      uid = config.ids.uids.clickhouse;
      group = "clickhouse";
      description = "ClickHouse server user";
    };

    users.groups.clickhouse.gid = config.ids.gids.clickhouse;

    systemd.services.clickhouse = {
      description = "ClickHouse server";

      wantedBy = [ "multi-user.target" ];

      after = [ "network.target" ];

      serviceConfig = {
        Type = "notify";
        User = "clickhouse";
        Group = "clickhouse";
        ConfigurationDirectory = "clickhouse-server";
        AmbientCapabilities = "CAP_SYS_NICE";
        StateDirectory = "clickhouse";
        LogsDirectory = "clickhouse";
        ExecStart = "${cfg.package}/bin/clickhouse-server --config-file=/etc/clickhouse-server/config.xml";
        TimeoutStartSec = "infinity";
      };

      environment = {
        # Switching off watchdog is very important for sd_notify to work correctly.
        CLICKHOUSE_WATCHDOG_ENABLE = "0";
      };
    };

    environment.etc = {
      "clickhouse-server/config.xml" = {
        source = cfg.package + "/etc/clickhouse-server/config.xml";
      };

      "clickhouse-server/users.xml" = {
        source = cfg.usersXml;
      };
    };

    environment.systemPackages = [ cfg.package ];

    # startup requires a `/etc/localtime` which only if exists if `time.timeZone != null`
    time.timeZone = lib.mkDefault "UTC";

  };

}

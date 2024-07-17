{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.clickhouse;
in
with lib;
{

  ###### interface

  options = {

    services.clickhouse = {

      enable = mkEnableOption "ClickHouse database server";

      package = mkPackageOption pkgs "clickhouse" { };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

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
        source = "${cfg.package}/etc/clickhouse-server/config.xml";
      };

      "clickhouse-server/users.xml" = {
        source = "${cfg.package}/etc/clickhouse-server/users.xml";
      };
    };

    environment.systemPackages = [ cfg.package ];

    # startup requires a `/etc/localtime` which only if exists if `time.timeZone != null`
    time.timeZone = mkDefault "UTC";

  };

}

{ config, lib, pkgs, ... }:
let
  cfg = config.services.clickhouse;
in
with lib;
{

  ###### interface

  options = {

    services.clickhouse = {

      enable = mkOption {
        default = false;
        description = "Whether to enable ClickHouse database server.";
      };

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
        User = "clickhouse";
        Group = "clickhouse";
        ConfigurationDirectory = "clickhouse-server";
        StateDirectory = "clickhouse";
        LogsDirectory = "clickhouse";
        ExecStart = "${pkgs.clickhouse}/bin/clickhouse-server --config-file=${pkgs.clickhouse}/etc/clickhouse-server/config.xml";
      };
    };

    environment.etc = {
      "clickhouse-server/config.xml" = {
        source = "${pkgs.clickhouse}/etc/clickhouse-server/config.xml";
      };

      "clickhouse-server/users.xml" = {
        source = "${pkgs.clickhouse}/etc/clickhouse-server/users.xml";
      };
    };

    environment.systemPackages = [ pkgs.clickhouse ];

    # startup requires a `/etc/localtime` which only if exists if `time.timeZone != null`
    time.timeZone = mkDefault "UTC";

  };

}

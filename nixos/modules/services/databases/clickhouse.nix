{ config, lib, pkgs, ... }:
let
  cfg = config.services.clickhouse;
  confDir = "/etc/clickhouse-server";
  stateDir = "/var/lib/clickhouse";
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

    users.extraUsers.clickhouse = {
      name = "clickhouse";
      uid = config.ids.uids.clickhouse;
      group = "clickhouse";
      description = "ClickHouse server user";
    };

    users.extraGroups.clickhouse.gid = config.ids.gids.clickhouse;

    systemd.services.clickhouse = {
      description = "ClickHouse server";

      wantedBy = [ "multi-user.target" ];

      after = [ "network.target" ];

      preStart = ''
        mkdir -p ${stateDir}
        chown clickhouse:clickhouse ${confDir} ${stateDir}
      '';

      script = ''
        cd "${confDir}"
        exec ${pkgs.clickhouse}/bin/clickhouse-server
      '';

      serviceConfig = {
        User = "clickhouse";
        Group = "clickhouse";
        PermissionsStartOnly = true;
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

  };

}

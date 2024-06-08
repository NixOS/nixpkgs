{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.geoserver;

in
{
  options = {
    services.geoserver = {
      enable = mkEnableOption "Geoserver service";

      package = lib.mkPackageOption pkgs "geoserver" { };

      user = mkOption {
        type = types.str;
        default = "geoserver";
        description = "User which runs Geoserver.";
      };

      group = mkOption {
        type = types.str;
        default = "geoserver";
        description = "Group which runs Geoserver.";
      };

      datadir = mkOption {
        type = types.str;
        default = "/var/lib/geoserver";
        description = "The data directory where data & its configuration is stored.";
      };

      jvmOpts = mkOption {
        type = types.lines;
        default = "";
        description = "Any options passed to the JVM.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      home = "${cfg.datadir}";
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    systemd.services.geoserver = {
      description = "Geoserver";

      wantedBy = [ "multi-user.target" ];

      environment = {
        GEOSERVER_HOME = "${cfg.package}/share/geoserver";
        GEOSERVER_DATA_DIR = "${cfg.datadir}";
        JAVA_OPTS = "${cfg.jvmOpts}";
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/geoserver-startup";
        ExecStop = "${cfg.package}/bin/geoserver-shutdown";
        PrivateTmp = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ teams.geospatial.members ];
}


{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.geoserver;
  dataDir = "/var/lib/geoserver";

in
{
  options = {
    services.geoserver = {
      enable = mkEnableOption "Geoserver service";

      package = lib.mkPackageOption pkgs "geoserver" { };

      jvmOpts = mkOption {
        type = types.lines;
        default = "";
        description = "Any options passed to the JVM.";
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.geoserver = {
      description = "Geoserver";

      wantedBy = [ "multi-user.target" ];

      environment = {
        GEOSERVER_HOME = "${cfg.package}/share/geoserver";
        GEOSERVER_DATA_DIR = "${dataDir}";
        JAVA_OPTS = "${cfg.jvmOpts}";
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/geoserver-startup";
        ExecStop = "${cfg.package}/bin/geoserver-shutdown";
        DynamicUser = true;
        NoNewPrivileges = true;
        ProtectHome = true; # true=deny access to /home, /root, /run/user
        StateDirectory = "geoserver";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ teams.geospatial.members ];
}


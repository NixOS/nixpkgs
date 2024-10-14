{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.geoserver;

in
{
  options = {
    services.geoserver = {
      enable = mkEnableOption "Geoserver service";

      package = lib.mkPackageOption pkgs "geoserver" { };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/geoserver";
        description = ''
          The data directory of the server.

          When a non-default location is used, the systemd unit will get a bind
          mount to it. Furthermore, the directory must exist, be writeable for
          the dynamic user and outside of protected directories (e.g. /home).
        '';
      };

      jvmOpts = mkOption {
        type = types.lines;
        default = "";
        description = "Any options passed to the JVM.";
      };

      jettyOpts = mkOption {
        type = types.lines;
        default = "";
        example = "jetty.http.port=1234";
        description = "Any options passed to the Jetty web server.";
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.geoserver = {
      description = "Geoserver";

      wantedBy = [ "multi-user.target" ];

      environment = {
        GEOSERVER_HOME = "${cfg.package}/share/geoserver";
        GEOSERVER_DATA_DIR = "/var/lib/geoserver";
        JAVA_OPTS = "${cfg.jvmOpts}";
        JETTY_OPTS = "${cfg.jettyOpts}";
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/geoserver-startup";
        ExecStop = "${cfg.package}/bin/geoserver-shutdown";
        DynamicUser = true;
        NoNewPrivileges = true;
        ProtectHome = true; # true=deny access to /home, /root, /run/user
        StateDirectory = "geoserver";
        BindPaths = [ "${cfg.dataDir}:/var/lib/geoserver" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ teams.geospatial.members ];
}

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

      user = mkOption {
        type = types.str;
        default = "geoserver";
        description = "The (system) user that will run the service.";
      };

      group = mkOption {
        type = types.str;
        default = "geoserver";
        description = "The user's group.";
      };

      jvmOpts = mkOption {
        type = types.lines;
        default = "";
        description = "Any options passed to the JVM via the `JAVA_OPTS` environment variable. See [startup.sh](https://github.com/geoserver/geoserver/blob/main/src/release/bin/startup.sh) for details.";
      };

      jettyOpts = mkOption {
        type = types.lines;
        default = "";
        example = "jetty.http.port=1234";
        description = "Any options passed to the Jetty web server via the `JETTY_OPTS` environment variable. See [startup.sh](https://github.com/geoserver/geoserver/blob/main/src/release/bin/startup.sh) for details.";
      };
    };
  };

  config = mkIf cfg.enable {

    users.users."${cfg.user}" = {
      group = cfg.group;
      isSystemUser = true;
    };
    users.groups."${cfg.group}" = { };

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
        User = cfg.user;
        Group = cfg.group;
        NoNewPrivileges = true;
        ProtectHome = true; # true=deny access to /home, /root, /run/user
        StateDirectory = "geoserver";
      };
    };
  };

  meta.teams = [ lib.teams.geospatial ];
}

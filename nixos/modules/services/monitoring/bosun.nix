{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bosun;

  configFile = pkgs.writeText "bosun.conf" ''
    ${lib.optionalString (cfg.opentsdbHost != null) "tsdbHost = ${cfg.opentsdbHost}"}
    ${lib.optionalString (cfg.influxHost != null) "influxHost = ${cfg.influxHost}"}
    httpListen = ${cfg.listenAddress}
    stateFile = ${cfg.stateFile}
    ledisDir = ${cfg.ledisDir}
    checkFrequency = ${cfg.checkFrequency}

    ${cfg.extraConfig}
  '';

in
{

  options = {

    services.bosun = {

      enable = lib.mkEnableOption "bosun";

      package = lib.mkPackageOption pkgs "bosun" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "bosun";
        description = ''
          User account under which bosun runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "bosun";
        description = ''
          Group account under which bosun runs.
        '';
      };

      opentsdbHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "localhost:4242";
        description = ''
          Host and port of the OpenTSDB database that stores bosun data.
          To disable opentsdb you can pass null as parameter.
        '';
      };

      influxHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "localhost:8086";
        description = ''
          Host and port of the influxdb database.
        '';
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = ":8070";
        description = ''
          The host address and port that bosun's web interface will listen on.
        '';
      };

      stateFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/bosun/bosun.state";
        description = ''
          Path to bosun's state file.
        '';
      };

      ledisDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/bosun/ledis_data";
        description = ''
          Path to bosun's ledis data dir
        '';
      };

      checkFrequency = lib.mkOption {
        type = lib.types.str;
        default = "5m";
        description = ''
          Bosun's check frequency
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration options for Bosun. You should describe your
          desired templates, alerts, macros, etc through this configuration
          option.

          A detailed description of the supported syntax can be found at-spi2-atk
          <https://bosun.org/configuration.html>
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.bosun = {
      description = "bosun metrics collector (part of Bosun)";
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p "$(dirname "${cfg.stateFile}")";
        touch "${cfg.stateFile}"
        touch "${cfg.stateFile}.tmp"

        mkdir -p "${cfg.ledisDir}";

        if [ "$(id -u)" = 0 ]; then
          chown ${cfg.user}:${cfg.group} "${cfg.stateFile}"
          chown ${cfg.user}:${cfg.group} "${cfg.stateFile}.tmp"
          chown ${cfg.user}:${cfg.group} "${cfg.ledisDir}"
        fi
      '';

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${cfg.package}/bin/bosun -c ${configFile}
        '';
      };
    };

    users.users.bosun = {
      description = "bosun user";
      group = "bosun";
      uid = config.ids.uids.bosun;
    };

    users.groups.bosun.gid = config.ids.gids.bosun;

  };

}

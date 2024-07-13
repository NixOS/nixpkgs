{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.osquery;
  dirname = path: with lib.strings; with lib.lists; concatStringsSep "/"
    (init (splitString "/" (normalizePath path)));

  # conf is the osquery configuration file used when the --config_plugin=filesystem.
  # filesystem is the osquery default value for the config_plugin flag.
  conf = pkgs.writeText "osquery.conf" (builtins.toJSON cfg.settings);

  # flagfile is the file containing osquery command line flags to be
  # provided to the application using the special --flagfile option.
  flagfile = pkgs.writeText "osquery.flags"
    (concatStringsSep "\n"
      (mapAttrsToList (name: value: "--${name}=${value}")
        # Use the conf derivation if not otherwise specified.
        ({ config_path = conf; } // cfg.flags)));

  osqueryi = pkgs.runCommand "osqueryi" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.osquery}/bin/osqueryi $out/bin/osqueryi \
      --add-flags "--flagfile ${flagfile} --disable-database"
  '';
in
{
  options.services.osquery = {
    enable = mkEnableOption "osqueryd daemon";

    settings = mkOption {
      default = { };
      description = ''
        Configuration to be written to the osqueryd JSON configuration file.
        To understand the configuration format, refer to https://osquery.readthedocs.io/en/stable/deployment/configuration/#configuration-components.
      '';
      example = {
        options.utc = false;
      };
      type = types.attrs;
    };

    flags = mkOption {
      default = { };
      description = ''
        Attribute set of flag names and values to be written to the osqueryd flagfile.
        For more information, refer to https://osquery.readthedocs.io/en/stable/installation/cli-flags.
      '';
      example = {
        config_refresh = "10";
      };
      type = with types;
        submodule {
          freeformType = attrsOf str;
          options = {
            database_path = mkOption {
              default = "/var/lib/osquery/osquery.db";
              readOnly = true;
              description = "Path used for the database file.";
              type = path;
            };
            logger_path = mkOption {
              default = "/var/log/osquery";
              readOnly = true;
              description = "Base directory used for logging.";
              type = path;
            };
            pidfile = mkOption {
              default = "/run/osquery/osqueryd.pid";
              readOnly = true;
              description = "Path used for pid file.";
              type = path;
            };
          };
        };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ osqueryi ];
    systemd.services.osqueryd = {
      after = [ "network.target" "syslog.service" ];
      description = "The osquery daemon";
      serviceConfig = {
        ExecStart = "${pkgs.osquery}/bin/osqueryd --flagfile ${flagfile}";
        PIDFile = cfg.flags.pidfile;
        LogsDirectory = cfg.flags.logger_path;
        StateDirectory = dirname cfg.flags.database_path;
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
    };
    systemd.tmpfiles.settings."10-osquery".${dirname (cfg.flags.pidfile)}.d = {
      user = "root";
      group = "root";
      mode = "0755";
    };
  };
}

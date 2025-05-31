{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.osquery;
  dirname =
    path:
    with lib.strings;
    with lib.lists;
    concatStringsSep "/" (init (splitString "/" (normalizePath path)));

  # conf is the osquery configuration file used when the --config_plugin=filesystem.
  # filesystem is the osquery default value for the config_plugin flag.
  conf = pkgs.writeText "osquery.conf" (builtins.toJSON cfg.settings);

  # flagfile is the file containing osquery command line flags to be
  # provided to the application using the special --flagfile option.
  flagfile = pkgs.writeText "osquery.flags" (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "--${name}=${value}")
        # Use the conf derivation if not otherwise specified.
        ({ config_path = conf; } // cfg.flags)
    )
  );

  osqueryi = pkgs.runCommand "osqueryi" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.osquery}/bin/osqueryi $out/bin/osqueryi \
      --add-flags "--flagfile ${flagfile} --disable-database"
  '';
in
{
  options.services.osquery = {
    enable = lib.mkEnableOption "osqueryd daemon";

    settings = lib.mkOption {
      default = { };
      description = ''
        Configuration to be written to the osqueryd JSON configuration file.
        To understand the configuration format, refer to <https://osquery.readthedocs.io/en/stable/deployment/configuration/#configuration-components>.
      '';
      example = {
        options.utc = false;
      };
      type = lib.types.attrs;
    };

    flags = lib.mkOption {
      default = { };
      description = ''
        Attribute set of flag names and values to be written to the osqueryd flagfile.
        For more information, refer to <https://osquery.readthedocs.io/en/stable/installation/cli-flags>.
      '';
      example = {
        config_refresh = "10";
      };
      type =
        with lib.types;
        submodule {
          freeformType = attrsOf str;
          options = {
            database_path = lib.mkOption {
              default = "/var/lib/osquery/osquery.db";
              readOnly = true;
              description = ''
                Path used for the database file.

                ::: {.note}
                If left as the default value, this directory will be automatically created before the
                service starts, otherwise you are responsible for ensuring the directory exists with
                the appropriate ownership and permissions.
              '';
              type = path;
            };
            logger_path = lib.mkOption {
              default = "/var/log/osquery";
              readOnly = true;
              description = ''
                Base directory used for logging.

                ::: {.note}
                If left as the default value, this directory will be automatically created before the
                service starts, otherwise you are responsible for ensuring the directory exists with
                the appropriate ownership and permissions.
              '';
              type = path;
            };
            pidfile = lib.mkOption {
              default = "/run/osquery/osqueryd.pid";
              readOnly = true;
              description = "Path used for pid file.";
              type = path;
            };
          };
        };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ osqueryi ];
    systemd.services.osqueryd = {
      after = [
        "network.target"
        "syslog.service"
      ];
      description = "The osquery daemon";
      serviceConfig = {
        ExecStart = "${pkgs.osquery}/bin/osqueryd --flagfile ${flagfile}";
        PIDFile = cfg.flags.pidfile;
        LogsDirectory = lib.mkIf (cfg.flags.logger_path == "/var/log/osquery") [ "osquery" ];
        StateDirectory = lib.mkIf (cfg.flags.database_path == "/var/lib/osquery/osquery.db") [ "osquery" ];
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

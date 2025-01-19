{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.garage;
  toml = pkgs.formats.toml { };
  configFile = toml.generate "garage.toml" cfg.settings;

  anyHasPrefix =
    prefix: strOrList:
    if isString strOrList then
      hasPrefix prefix strOrList
    else
      any ({ path, ... }: hasPrefix prefix path) strOrList;
in
{
  meta = {
    doc = ./garage.md;
    maintainers = [ maintainers.mjm ];
  };

  options.services.garage = {
    enable = mkEnableOption "Garage Object Storage (S3 compatible)";

    extraEnvironment = mkOption {
      type = types.attrsOf types.str;
      description = "Extra environment variables to pass to the Garage server.";
      default = { };
      example = {
        RUST_BACKTRACE = "yes";
      };
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      description = "File containing environment variables to be passed to the Garage server.";
      default = null;
    };

    logLevel = mkOption {
      type = types.enum ([
        "error"
        "warn"
        "info"
        "debug"
        "trace"
      ]);
      default = "info";
      example = "debug";
      description = "Garage log level, see <https://garagehq.deuxfleurs.fr/documentation/quick-start/#launching-the-garage-server> for examples.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = toml.type;

        options = {
          metadata_dir = mkOption {
            default = "/var/lib/garage/meta";
            type = types.path;
            description = "The metadata directory, put this on a fast disk (e.g. SSD) if possible.";
          };

          data_dir = mkOption {
            default = "/var/lib/garage/data";
            example = [
              {
                path = "/var/lib/garage/data";
                capacity = "2T";
              }
            ];
            type = with types; either path (listOf attrs);
            description = ''
              The directory in which Garage will store the data blocks of objects. This folder can be placed on an HDD.
              Since v0.9.0, Garage supports multiple data directories, refer to https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/#data_dir for the exact format.
            '';
          };
        };
      };
      description = "Garage configuration, see <https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/> for reference.";
    };

    package = mkOption {
      type = types.package;
      description = "Garage package to use, needs to be set explicitly. If you are upgrading from a major version, please read NixOS and Garage release notes for upgrade instructions.";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."garage.toml" = {
      source = configFile;
    };

    # For administration
    environment.systemPackages = [
      (pkgs.writeScriptBin "garage" ''
        # make it so all future variables set are automatically exported as environment variables
        set -a

        # source the set environmentFile (since systemd EnvironmentFile is supposed to be a minor subset of posix sh parsing) (with shell arg escaping to avoid quoting issues)
        [ -f ${lib.escapeShellArg cfg.environmentFile} ] && . ${lib.escapeShellArg cfg.environmentFile}

        # exec the program with quoted args (also with shell arg escaping for the program path to avoid quoting issues there)
        exec ${lib.escapeShellArg (lib.getExe cfg.package)} "$@"
      '')
    ];

    systemd.services.garage = {
      description = "Garage Object Storage (S3 compatible)";
      after = [
        "network.target"
        "network-online.target"
      ];
      wants = [
        "network.target"
        "network-online.target"
      ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        configFile
      ] ++ (lib.optional (cfg.environmentFile != null) cfg.environmentFile);
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/garage server";

        StateDirectory = mkIf (
          anyHasPrefix "/var/lib/garage" cfg.settings.data_dir
          || hasPrefix "/var/lib/garage" cfg.settings.metadata_dir
        ) "garage";
        DynamicUser = lib.mkDefault true;
        ProtectHome = true;
        NoNewPrivileges = true;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
      environment = {
        RUST_LOG = lib.mkDefault "garage=${cfg.logLevel}";
      } // cfg.extraEnvironment;
    };
  };
}

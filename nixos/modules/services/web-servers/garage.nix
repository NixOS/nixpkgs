{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.garage;
  toml = pkgs.formats.toml { };
  configFile = toml.generate "garage.toml" cfg.settings;

  anyHasPrefix =
    prefix: strOrList:
    if lib.isString strOrList then
      lib.hasPrefix prefix strOrList
    else
      lib.any ({ path, ... }: lib.hasPrefix prefix path) strOrList;
in
{
  meta = {
    doc = ./garage.md;
    maintainers = [ lib.maintainers.mjm ];
  };

  options.services.garage = {
    enable = lib.mkEnableOption "Garage Object Storage (S3 compatible)";

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Extra environment variables to pass to the Garage server.";
      default = { };
      example = {
        RUST_BACKTRACE = "yes";
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "File containing environment variables to be passed to the Garage server.";
      default = null;
    };

    logLevel = lib.mkOption {
      type = lib.types.enum ([
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

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = toml.type;

        options = {
          metadata_dir = lib.mkOption {
            default = "/var/lib/garage/meta";
            type = lib.types.path;
            description = "The metadata directory, put this on a fast disk (e.g. SSD) if possible.";
          };

          data_dir = lib.mkOption {
            default = "/var/lib/garage/data";
            example = [
              {
                path = "/var/lib/garage/data";
                capacity = "2T";
              }
            ];
            type = with lib.types; either path (listOf attrs);
            description = ''
              The directory in which Garage will store the data blocks of objects. This folder can be placed on an HDD.
              Since v0.9.0, Garage supports multiple data directories, refer to https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/#data_dir for the exact format.
            '';
          };
        };
      };
      description = "Garage configuration, see <https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/> for reference.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "Garage package to use, needs to be set explicitly. If you are upgrading from a major version, please read NixOS and Garage release notes for upgrade instructions.";
    };
  };

  config = lib.mkIf cfg.enable {
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

        StateDirectory = lib.mkIf (
          anyHasPrefix "/var/lib/garage" cfg.settings.data_dir
          || lib.hasPrefix "/var/lib/garage" cfg.settings.metadata_dir
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

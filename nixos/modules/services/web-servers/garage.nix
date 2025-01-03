{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.garage;
  toml = pkgs.formats.toml { };
  configFile = toml.generate "garage.toml" cfg.settings;
in
{
  meta = {
    doc = ./garage.md;
    maintainers = [ ];
  };

  options.services.garage = {
    enable = mkEnableOption "Garage Object Storage (S3 compatible)";

    extraEnvironment = mkOption {
      type = types.attrsOf types.str;
      description = "Extra environment variables to pass to the Garage server.";
      default = { };
      example = { RUST_BACKTRACE = "yes"; };
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      description = "File containing environment variables to be passed to the Garage server.";
      default = null;
    };

    logLevel = mkOption {
      type = types.enum ([ "error" "warn" "info" "debug" "trace" ]);
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
            example = [ {
              path = "/var/lib/garage/data";
              capacity = "2T";
            } ];
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

    assertions = [
      # We removed our module-level default for replication_mode. If a user upgraded
      # to garage 1.0.0 while relying on the module-level default, they would be left
      # with a config which evaluates and builds, but then garage refuses to start
      # because either replication_factor or replication_mode is required.
      # The replication_factor option also was `toString`'ed before, which is
      # now not possible anymore, so we prompt the user to change it to a string
      # if present.
      # These assertions can be removed in NixOS 24.11, when all users have been
      # warned once.
      {
        assertion = (cfg.settings ? replication_factor || cfg.settings ? replication_mode) || lib.versionOlder cfg.package.version "1.0.0";
        message = ''
          Garage 1.0.0 requires an explicit replication factor to be set.
          Please set replication_factor to 1 explicitly to preserve the previous behavior.
          https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v1.0.0/doc/book/reference-manual/configuration.md#replication_factor

        '';
      }
      {
        assertion = lib.isString (cfg.settings.replication_mode or "");
        message = ''
          The explicit `replication_mode` option in `services.garage.settings`
          has been removed and is now handled by the freeform settings in order
          to allow it being completely absent (for Garage 1.x).
          That module option previously `toString`'ed the value it's configured
          with, which is now no longer possible.

          You're still using a non-string here, please manually set it to
          a string, or migrate to the separate setting keys introduced in 1.x.

          Refer to https://garagehq.deuxfleurs.fr/documentation/working-documents/migration-1/
          for the migration guide.
        '';
      }
    ];

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
      after = [ "network.target" "network-online.target" ];
      wants = [ "network.target" "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ] ++ (lib.optional (cfg.environmentFile != null) cfg.environmentFile);
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/garage server";

        StateDirectory = mkIf (hasPrefix "/var/lib/garage" cfg.settings.data_dir || hasPrefix "/var/lib/garage" cfg.settings.metadata_dir) "garage";
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

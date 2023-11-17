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
    maintainers = with pkgs.lib.maintainers; [ raitobezarius ];
  };

  options.services.garage = {
    enable = mkEnableOption (lib.mdDoc "Garage Object Storage (S3 compatible)");

    extraEnvironment = mkOption {
      type = types.attrsOf types.str;
      description = lib.mdDoc "Extra environment variables to pass to the Garage server.";
      default = { };
      example = { RUST_BACKTRACE = "yes"; };
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      description = lib.mdDoc "File containing environment variables to be passed to the Garage server.";
      default = null;
    };

    logLevel = mkOption {
      type = types.enum ([ "info" "debug" "trace" ]);
      default = "info";
      example = "debug";
      description = lib.mdDoc "Garage log level, see <https://garagehq.deuxfleurs.fr/documentation/quick-start/#launching-the-garage-server> for examples.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = toml.type;

        options = {
          metadata_dir = mkOption {
            default = "/var/lib/garage/meta";
            type = types.path;
            description = lib.mdDoc "The metadata directory, put this on a fast disk (e.g. SSD) if possible.";
          };

          data_dir = mkOption {
            default = "/var/lib/garage/data";
            type = types.path;
            description = lib.mdDoc "The main data storage, put this on your large storage (e.g. high capacity HDD)";
          };

          replication_mode = mkOption {
            default = "none";
            type = types.enum ([ "none" "1" "2" "3" "2-dangerous" "3-dangerous" "3-degraded" 1 2 3 ]);
            apply = v: toString v;
            description = lib.mdDoc "Garage replication mode, defaults to none, see: <https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/#replication-mode> for reference.";
          };
        };
      };
      description = lib.mdDoc "Garage configuration, see <https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/> for reference.";
    };

    package = mkOption {
      type = types.package;
      description = lib.mdDoc "Garage package to use, needs to be set explicitly. If you are upgrading from a major version, please read NixOS and Garage release notes for upgrade instructions.";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."garage.toml" = {
      source = configFile;
    };

    environment.systemPackages = [ cfg.package ]; # For administration

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

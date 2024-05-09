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
    maintainers = with pkgs.lib.maintainers; [ raitobezarius tcheronneau ];
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

    systemdLoadCredential = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Optional load credential for systemd. Useful if you want to use sops or agenix to manage your secrets.";
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
            type = types.path;
            description = "The main data storage, put this on your large storage (e.g. high capacity HDD)";
          };

          rpc_bind_addr = mkOption {
            default = "[::]:3901";
            type = types.str;
            description = "The address and port on which to bind for inter-cluster communications.";
          };
        };
      };
      description = "Garage configuration, see <https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/> for reference.";
    };

    package = mkPackageOptionMD pkgs "garage" { };
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
        LoadCredential = [] ++ cfg.systemdLoadCredential;
      };
      environment = {
        RUST_LOG = lib.mkDefault "garage=${cfg.logLevel}";
      } // cfg.extraEnvironment;
    };
  };
}

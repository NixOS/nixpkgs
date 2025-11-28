{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.fishnet;

  format = pkgs.formats.ini {
    # Skip null values.
    mkKeyValue = k: v: lib.optionalString (v != null) (lib.generators.mkKeyValueDefault { } "=" k v);
  };
in
{

  ###### interface

  options.services.fishnet = {
    enable = lib.mkEnableOption "fishnet: distributed Stockfish analysis for lichess.org";

    package = lib.mkPackageOption pkgs "fishnet" { };

    # This option cannot be set from the ini configuration file (as of fishnet v2.7.1).
    keyfile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to file containing the fishnet key.
        See https://lichess.org/get-fishnet
        Either settings.fishnet.key or keyfile must be set.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;

        options.fishnet = {
          key = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Fishnet key.
              See https://lichess.org/get-fishnet
              Either settings.fishnet.key or keyfile must be set.
            '';
          };

          cores = lib.mkOption {
            type = lib.types.either lib.types.int (
              lib.types.enum [
                "auto"
                "all"
              ]
            );
            default = "auto";
            description = ''
              Number of logical CPU cores to use for engine processes (or
              "auto" for all cores but one, or "all" for all cores).
            '';
          };

          systembacklog = lib.mkOption {
            type = lib.types.str;
            default = "0";
            example = [
              "2h"
              "short"
              "long"
            ];
            description = ''
              Prefer to run low-priority jobs only if older than this duration.
            '';
          };

          userbacklog = lib.mkOption {
            type = lib.types.str;
            default = "0";
            example = [
              "120s"
              "short"
              "long"
            ];
            description = ''
              Prefer to run high-priority jobs only if older than this duration.
            '';
          };
        };
      };

      default = { };

      description = ''
        Configuration for `fishnet`. See `fishnet -h`.
      '';
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = (cfg.settings.fishnet.key == null) != (cfg.keyfile == null);
      message = "Either settings.fishnet.key or keyfile must be set.";
    };

    systemd.services.fishnet = {
      description = "Fishnet client";

      serviceConfig =
        let
          stateDirectory = "fishnet";
        in
        {
          ExecStart = "${cfg.package}/bin/fishnet --conf ${format.generate "fishnet.ini" cfg.settings} ${
            lib.optionalString (cfg.keyfile != null) "--key-file ${lib.escapeShellArg cfg.keyfile}"
          } --stats-file /var/lib/${stateDirectory}/fishnet-stats run";

          ProtectHome = true;
          DynamicUser = true;
          StateDirectory = stateDirectory;

          # From `fishnet systemd`, settings implied from DynamicUser were removed.
          KillMode = "mixed";
          Nice = 5;
          CapabilityBoundingSet = "";
          PrivateDevices = true;
          DevicePolicy = "closed";
          Restart = "on-failure";
        };
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = lib.maintainers.oliviermarty;
}

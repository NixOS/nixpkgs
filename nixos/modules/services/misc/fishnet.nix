{ config, lib, pkgs, ... }:

let
  cfg = config.services.fishnet;

  format = pkgs.formats.ini {
    # Skip null values.
    mkKeyValue = k: v:
      if v == null then ""
      else lib.generators.mkKeyValueDefault {} "=" k v;
  };
in with lib; {

  ###### interface

  options.services.fishnet = {
    enable = mkEnableOption (mdDoc "fishnet: distributed Stockfish analysis for lichess.org");

    package = mkOption {
      type = types.package;
      default = pkgs.fishnet;
      defaultText = literalExpression "pkgs.fishnet";
      description = mdDoc ''
        Which fishnet package to use.
      '';
    };

    # This option cannot be set from the ini configuration file (as of fishnet v2.7.1).
    keyfile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = mdDoc ''
        Path to file containing the fishnet key.
        See https://lichess.org/get-fishnet
        Either settings.Fishnet.Key or keyfile must be set.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;

        options.Fishnet = {
          Key = mkOption {
            type = with types; nullOr str;
            default = null;
            description = mdDoc ''
              Fishnet key.
              See https://lichess.org/get-fishnet
              Either settings.Fishnet.Key or keyfile must be set.
            '';
          };

          Cores = mkOption {
            type = with types; either int (enum ["auto" "all"]);
            default = "auto";
            description = mdDoc ''
              Number of logical CPU cores to use for engine processes (or
              "auto" for all cores but one, or "all" for all cores).
            '';
          };

          SystemBacklog = mkOption {
            type = types.str;
            default = "0";
            example = ["2h" "short" "long"];
            description = mdDoc ''
              Prefer to run low-priority jobs only if older than this duration.
            '';
          };

          UserBacklog = mkOption {
            type = types.str;
            default = "0";
            example = ["120s" "short" "long"];
            description = mdDoc ''
              Prefer to run high-priority jobs only if older than this duration.
            '';
          };
        };
      };

      default = {};

      description = mdDoc ''
        Configuration for `fishnet`. See `fishnet -h`.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.fishnet = {
      description = "Fishnet client";

      serviceConfig = let stateDirectory = "fishnet"; in {
        ExecStart = "${pkgs.fishnet}/bin/fishnet --conf ${format.generate "fishnet.ini" cfg.settings} ${optionalString (cfg.keyfile != null) "--key-file ${escapeShellArg cfg.keyfile}"} --stats-file /var/lib/${stateDirectory}/fishnet-stats run";

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

    assertions = singleton {
      assertion = (cfg.settings.Fishnet.Key == null) != (cfg.keyfile == null);
      message = "Either settings.Fishnet.Key or keyfile must be set.";
    };
  };

  meta.maintainers = maintainers.oliviermarty;
}

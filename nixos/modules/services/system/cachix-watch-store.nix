{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cachix-watch-store;
in
{
  meta.maintainers = [ lib.maintainers.jfroche lib.maintainers.domenkozar ];

  options.services.cachix-watch-store = {
    enable = mkEnableOption (lib.mdDoc "Cachix Watch Store: https://docs.cachix.org");

    cacheName = mkOption {
      type = types.str;
      description = lib.mdDoc "Cachix binary cache name";
    };

    cachixTokenFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Required file that needs to contain the cachix auth token.
      '';
    };

    compressionLevel = mkOption {
      type = types.nullOr types.int;
      description = lib.mdDoc "The compression level for ZSTD compression (between 0 and 16)";
      default = null;
    };

    jobs = mkOption {
      type = types.nullOr types.int;
      description = lib.mdDoc "Number of threads used for pushing store paths";
      default = null;
    };

    host = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc "Cachix host to connect to";
    };

    verbose = mkOption {
      type = types.bool;
      description = lib.mdDoc "Enable verbose output";
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cachix;
      defaultText = literalExpression "pkgs.cachix";
      description = lib.mdDoc "Cachix Client package to use.";
    };

  };

  config = mkIf cfg.enable {
    systemd.services.cachix-watch-store-agent = {
      description = "Cachix watch store Agent";
      after = [ "network-online.target" ];
      path = [ config.nix.package ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        # allow to restart indefinitely
        StartLimitIntervalSec = 0;
      };
      serviceConfig = {
        # don't put too much stress on the machine when restarting
        RestartSec = 1;
        # we don't want to kill children processes as those are deployments
        KillMode = "process";
        Restart = "on-failure";
        DynamicUser = true;
        LoadCredential = [
          "cachix-token:${toString cfg.cachixTokenFile}"
        ];
      };
      script =
        let
          command = [ "${cfg.package}/bin/cachix" ]
            ++ (lib.optional cfg.verbose "--verbose") ++ (lib.optionals (cfg.host != null) [ "--host" cfg.host ])
            ++ [ "watch-store" ] ++ (lib.optionals (cfg.compressionLevel != null) [ "--compression-level" (toString cfg.compressionLevel) ])
            ++ (lib.optionals (cfg.jobs != null) [ "--jobs" (toString cfg.jobs) ]) ++ [ cfg.cacheName ];
        in
        ''
          export CACHIX_AUTH_TOKEN="$(<"$CREDENTIALS_DIRECTORY/cachix-token")"
          ${lib.escapeShellArgs command}
        '';
    };
  };
}

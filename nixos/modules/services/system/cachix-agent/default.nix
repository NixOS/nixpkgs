{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cachix-agent;
in {
  meta.maintainers = [ lib.maintainers.domenkozar ];

  options.services.cachix-agent = {
    enable = mkEnableOption "Cachix Deploy Agent: https://docs.cachix.org/deploy/";

    name = mkOption {
      type = types.str;
      description = "Agent name, usually same as the hostname";
      default = config.networking.hostName;
      defaultText = "config.networking.hostName";
    };

    verbose = mkOption {
      type = types.bool;
      description = "Enable verbose output";
      default = false;
    };

    profile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Profile name, defaults to 'system' (NixOS).";
    };

    host = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Cachix uri to use.";
    };

    package = mkPackageOption pkgs "cachix" { };

    credentialsFile = mkOption {
      type = types.path;
      default = "/etc/cachix-agent.token";
      description = ''
        Required file that needs to contain CACHIX_AGENT_TOKEN=...
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.cachix-agent = {
      description = "Cachix Deploy Agent";
      wants = [ "network-online.target" ];
      after = ["network-online.target"];
      path = [ config.nix.package ];
      wantedBy = [ "multi-user.target" ];

      # Cachix requires $USER to be set
      environment.USER = "root";

      # don't stop the service if the unit disappears
      unitConfig.X-StopOnRemoval = false;

      serviceConfig = {
        # we don't want to kill children processes as those are deployments
        KillMode = "process";
        Restart = "always";
        RestartSec = 5;
        EnvironmentFile = cfg.credentialsFile;
        ExecStart = ''
          ${cfg.package}/bin/cachix ${lib.optionalString cfg.verbose "--verbose"} ${lib.optionalString (cfg.host != null) "--host ${cfg.host}"} \
            deploy agent ${cfg.name} ${optionalString (cfg.profile != null) cfg.profile}
        '';
      };
    };
  };
}

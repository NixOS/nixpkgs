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

    profile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Profile name, defaults to 'system' (NixOS).";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cachix;
      defaultText = literalExpression "pkgs.cachix";
      description = "Cachix Client package to use.";
    };

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
      after = ["network-online.target"];
      path = [ config.nix.package ];
      wantedBy = [ "multi-user.target" ];
      # don't restart while changing
      reloadIfChanged = true;
      serviceConfig = {
        Restart = "on-failure";
        EnvironmentFile = cfg.credentialsFile;
        ExecStart = "${cfg.package}/bin/cachix deploy agent ${cfg.name} ${if cfg.profile != null then profile else ""}";
      };
    };
  };
}

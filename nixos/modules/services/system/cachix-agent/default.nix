{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.cachix-agent;
in
{
  meta.maintainers = lib.teams.cachix.members;

  options.services.cachix-agent = {
    enable = lib.mkEnableOption "Cachix Deploy Agent: <https://docs.cachix.org/deploy/>";

    name = lib.mkOption {
      type = lib.types.str;
      description = "Agent name, usually same as the hostname";
      default = config.networking.hostName;
      defaultText = "config.networking.hostName";
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      description = "Enable verbose output";
      default = false;
    };

    profile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Profile name, defaults to 'system' (NixOS).";
    };

    host = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Cachix uri to use.";
    };

    package = lib.mkPackageOption pkgs "cachix" { };

    credentialsFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/cachix-agent.token";
      description = ''
        Required file that needs to contain CACHIX_AGENT_TOKEN=...
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.cachix-agent = {
      description = "Cachix Deploy Agent";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
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
          ${cfg.package}/bin/cachix ${lib.optionalString cfg.verbose "--verbose"} ${
            lib.optionalString (cfg.host != null) "--host ${cfg.host}"
          } \
            deploy agent ${cfg.name} ${lib.optionalString (cfg.profile != null) cfg.profile}
        '';
      };
    };
  };
}

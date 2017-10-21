{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.ecs-agent;
in {
  options.services.ecs-agent = {
    enable = mkEnableOption "Amazon ECS agent";

    package = mkOption {
      type = types.path;
      description = "The ECS agent package to use";
      default = pkgs.ecs-agent;
      defaultText = "pkgs.ecs-agent";
    };

    extra-environment = mkOption {
      type = types.attrsOf types.str;
      description = "The environment the ECS agent should run with. See the ECS agent documentation for keys that work here.";
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    # This service doesn't run if docker isn't running, and unlike potentially remote services like e.g., postgresql, docker has
    # to be running locally so `docker.enable` will always be set if the ECS agent is enabled.
    virtualisation.docker.enable = true;

    systemd.services.ecs-agent = {
      inherit (cfg.package.meta) description;
      after    = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.extra-environment;

      script = ''
        if [ ! -z "$ECS_DATADIR" ]; then
          mkdir -p "$ECS_DATADIR"
        fi
        ${cfg.package.bin}/bin/agent
      '';
    };
  };
}


{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  bcfg = cfg.builds;

  rcfg = config.services.redis;
  inherit (import ./helpers.nix { inherit lib; }) redisOpts;
in {
  options = {
    services.sourcehut.builds = {
      redis = mkOption {
        type = types.submodule redisOpts;
        default = { hostname = rcfg.bind; port = rcfg.port; dbnumber = 0; };
        description = ''
          The redis connection used for the Celery worker.
        '';
      };

      worker.user = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "runner";
        description = ''
          builds.sr.ht runner user.
        '';
      };

      worker.name = mkOption {
        type = types.str;
        default = "runner.sr.ht.local";
        description = ''
          Name of this build runner.
        '';
      };

      # TODO: This needs a better default...
      # Instead of my random path...
      worker.buildLogs = mkOption {
        type = types.path;
        default = "/var/srht/logs";
        description = ''
          Path to the build logs.
        '';
      };

      worker.images = mkOption {
        type = types.path;
        default = "${bcfg.package}/lib/images";
        description = ''
          Path to the build images.
        '';
      };

      worker.controlCommand = mkOption {
        type = types.path;
        default = "${bcfg.package}/lib/images/control";
        description = ''
          In production you should NOT put the build user in the docker group. Instead,
          make a scratch user who is and write a sudoers or doas.conf file that allows
          them to execute just the control command, then update this config option. For
          example:

          doas -u docker /var/lib/images/control

          Assuming doas.conf looks something like this:

          permit nopass builds as docker cmd /var/lib/images/control

          For more information about the security model of builds.sr.ht, visit the wiki:

          https://man.sr.ht/builds.sr.ht/installation.md#security-model
        '';
      };

      worker.timeout = mkOption {
        type = types.str;
        default = "45m";
        description = ''
          Max build duration. See https://golang.org/pkg/time/#ParseDuration.
        '';
      };

      worker.extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration for builds.sr.ht::worker.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf bcfg.enable {
      assertions =
        [
          { assertion = bcfg.enable -> bcfg.oauth.clientId != "" && bcfg.oauth.clientSecret != "";
            message = "OAuth credentials needs to be configured for builds.sr.ht to implement the service"; }
        ];

      users = {
        users = singleton {
          name = bcfg.user;
          group = bcfg.user;
          description = "builds.sr.ht user";
        };

        groups = singleton {
          name = bcfg.user;
        };
      };

      systemd.services."builds.sr.ht" = {
        after = [ "redis.service" "postgresql.service" "network.target" ];
        requires = [ "redis.service" "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "builds.sr.ht website service";

        script = ''
          gunicorn buildsrht.app:app \
            -b ${cfg.address}:${toString bcfg.port}
        '';
      };
    })

    (mkIf (bcfg.worker.user != null) {
      users = {
        users = singleton {
          name = bcfg.worker.user;
          group = bcfg.worker.user;
          extraGroups = [ "kvm" "docker" ];
          description = "builds.sr.ht runner user";
        };

        groups = singleton {
          name = bcfg.worker.user;
        };
      };

      virtualisation.docker.enable = true;

      systemd = {
        tmpfiles.rules = [ ];

        services."builds.sr.ht-worker" = {
          after = [ "docker.target" "network.target" ];
          requires = [ "docker.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "builds.sr.ht worker";
          path = with pkgs; [ bcfg.package ];
          serviceConfig = {
            Type = "simple";
            User = bcfg.worker.user;
            Restart = "always";
          };

          script = ''
            builds.sr.ht-worker
          '';
        };
      };
    })
  ];
}

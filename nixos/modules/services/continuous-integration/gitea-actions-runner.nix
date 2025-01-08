{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (utils)
    escapeSystemdPath
    ;

  cfg = config.services.gitea-actions-runner;

  settingsFormat = pkgs.formats.yaml { };

  # Check whether any runner instance label requires a container runtime
  # Empty label strings result in the upstream defined defaultLabels, which require docker
  # https://gitea.com/gitea/act_runner/src/tag/v0.1.5/internal/app/cmd/register.go#L93-L98
  hasDockerScheme =
    instance: instance.labels == [ ] || lib.any (label: lib.hasInfix ":docker:" label) instance.labels;
  wantsContainerRuntime = lib.any hasDockerScheme (lib.attrValues cfg.instances);

  hasHostScheme = instance: lib.any (label: lib.hasSuffix ":host" label) instance.labels;

  # provide shorthands for whether container runtimes are enabled
  hasDocker = config.virtualisation.docker.enable;
  hasPodman = config.virtualisation.podman.enable;

  tokenXorTokenFile =
    instance:
    (instance.token == null && instance.tokenFile != null)
    || (instance.token != null && instance.tokenFile == null);
in
{
  meta.maintainers = with lib.maintainers; [
    hexa
  ];

  options.services.gitea-actions-runner = {
    package = lib.mkPackageOption pkgs "gitea-actions-runner" { };

    instances = lib.mkOption {
      default = { };
      description = ''
        Gitea Actions Runner instances.
      '';
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Gitea Actions Runner instance";

          name = lib.mkOption {
            type = lib.types.str;
            example = lib.literalExpression "config.networking.hostName";
            description = ''
              The name identifying the runner instance towards the Gitea/Forgejo instance.
            '';
          };

          url = lib.mkOption {
            type = lib.types.str;
            example = "https://forge.example.com";
            description = ''
              Base URL of your Gitea/Forgejo instance.
            '';
          };

          token = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Plain token to register at the configured Gitea/Forgejo instance.
            '';
          };

          tokenFile = lib.mkOption {
            type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
            default = null;
            description = ''
              Path to an environment file, containing the `TOKEN` environment
              variable, that holds a token to register at the configured
              Gitea/Forgejo instance.
            '';
          };

          labels = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            example = lib.literalExpression ''
              [
                # provide a debian base with nodejs for actions
                "debian-latest:docker://node:18-bullseye"
                # fake the ubuntu name, because node provides no ubuntu builds
                "ubuntu-latest:docker://node:18-bullseye"
                # provide native execution on the host
                #"native:host"
              ]
            '';
            description = ''
              Labels used to map jobs to their runtime environment. Changing these
              labels currently requires a new registration token.

              Many common actions require bash, git and nodejs, as well as a filesystem
              that follows the filesystem hierarchy standard.
            '';
          };
          settings = lib.mkOption {
            description = ''
              Configuration for `act_runner daemon`.
              See https://gitea.com/gitea/act_runner/src/branch/main/internal/pkg/config/config.example.yaml for an example configuration
            '';

            type = lib.types.submodule {
              freeformType = settingsFormat.type;
            };

            default = { };
          };

          hostPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = with pkgs; [
              bash
              coreutils
              curl
              gawk
              gitMinimal
              gnused
              nodejs
              wget
            ];
            defaultText = lib.literalExpression ''
              with pkgs; [
                bash
                coreutils
                curl
                gawk
                gitMinimal
                gnused
                nodejs
                wget
              ]
            '';
            description = ''
              List of packages, that are available to actions, when the runner is configured
              with a host execution label.
            '';
          };
        };
      });
    };
  };

  config = lib.mkIf (cfg.instances != { }) {
    assertions = [
      {
        assertion = lib.any tokenXorTokenFile (lib.attrValues cfg.instances);
        message = "Instances of gitea-actions-runner can have `token` or `tokenFile`, not both.";
      }
      {
        assertion = wantsContainerRuntime -> hasDocker || hasPodman;
        message = "Label configuration on gitea-actions-runner instance requires either docker or podman.";
      }
    ];

    systemd.services =
      let
        mkRunnerService =
          name: instance:
          let
            wantsContainerRuntime = hasDockerScheme instance;
            wantsHost = hasHostScheme instance;
            wantsDocker = wantsContainerRuntime && config.virtualisation.docker.enable;
            wantsPodman = wantsContainerRuntime && config.virtualisation.podman.enable;
            configFile = settingsFormat.generate "config.yaml" instance.settings;
          in
          lib.nameValuePair "gitea-runner-${escapeSystemdPath name}" {
            inherit (instance) enable;
            description = "Gitea Actions Runner";
            wants = [ "network-online.target" ];
            after =
              [
                "network-online.target"
              ]
              ++ lib.optionals (wantsDocker) [
                "docker.service"
              ]
              ++ lib.optionals (wantsPodman) [
                "podman.service"
              ];
            wantedBy = [
              "multi-user.target"
            ];
            environment =
              lib.optionalAttrs (instance.token != null) {
                TOKEN = "${instance.token}";
              }
              // lib.optionalAttrs (wantsPodman) {
                DOCKER_HOST = "unix:///run/podman/podman.sock";
              }
              // {
                HOME = "/var/lib/gitea-runner/${name}";
              };
            path =
              with pkgs;
              [
                coreutils
              ]
              ++ lib.optionals wantsHost instance.hostPackages;
            serviceConfig =
              {
                DynamicUser = true;
                User = "gitea-runner";
                StateDirectory = "gitea-runner";
                WorkingDirectory = "-/var/lib/gitea-runner/${name}";

                # gitea-runner might fail when gitea is restarted during upgrade.
                Restart = "on-failure";
                RestartSec = 2;

                ExecStartPre = [
                  (pkgs.writeShellScript "gitea-register-runner-${name}" ''
                    export INSTANCE_DIR="$STATE_DIRECTORY/${name}"
                    mkdir -vp "$INSTANCE_DIR"
                    cd "$INSTANCE_DIR"

                    # force reregistration on changed labels
                    export LABELS_FILE="$INSTANCE_DIR/.labels"
                    export LABELS_WANTED="$(echo ${lib.escapeShellArg (lib.concatStringsSep "\n" instance.labels)} | sort)"
                    export LABELS_CURRENT="$(cat $LABELS_FILE 2>/dev/null || echo 0)"

                    if [ ! -e "$INSTANCE_DIR/.runner" ] || [ "$LABELS_WANTED" != "$LABELS_CURRENT" ]; then
                      # remove existing registration file, so that changing the labels forces a re-registration
                      rm -v "$INSTANCE_DIR/.runner" || true

                      # perform the registration
                      ${cfg.package}/bin/act_runner register --no-interactive \
                        --instance ${lib.escapeShellArg instance.url} \
                        --token "$TOKEN" \
                        --name ${lib.escapeShellArg instance.name} \
                        --labels ${lib.escapeShellArg (lib.concatStringsSep "," instance.labels)} \
                        --config ${configFile}

                      # and write back the configured labels
                      echo "$LABELS_WANTED" > "$LABELS_FILE"
                    fi

                  '')
                ];
                ExecStart = "${cfg.package}/bin/act_runner daemon --config ${configFile}";
                SupplementaryGroups =
                  lib.optionals (wantsDocker) [
                    "docker"
                  ]
                  ++ lib.optionals (wantsPodman) [
                    "podman"
                  ];
              }
              // lib.optionalAttrs (instance.tokenFile != null) {
                EnvironmentFile = instance.tokenFile;
              };
          };
      in
      lib.mapAttrs' mkRunnerService cfg.instances;
  };
}

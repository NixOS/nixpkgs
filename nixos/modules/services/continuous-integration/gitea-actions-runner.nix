{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    any
    attrValues
    concatStringsSep
    escapeShellArg
    hasInfix
    hasSuffix
    optionalAttrs
    optionals
    literalExpression
    mapAttrs'
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    nameValuePair
    types
    ;

  inherit (utils)
    escapeSystemdPath
    ;

  cfg = config.services.gitea-actions-runner;

  settingsFormat = pkgs.formats.yaml { };

  # Check whether any runner instance label requires a container runtime
  # Empty label strings result in the upstream defined defaultLabels, which require docker
  # https://gitea.com/gitea/act_runner/src/tag/v0.1.5/internal/app/cmd/register.go#L93-L98
  hasDockerScheme =
    instance: instance.labels == [ ] || any (label: hasInfix ":docker:" label) instance.labels;
  wantsContainerRuntime = any hasDockerScheme (attrValues cfg.instances);

  hasHostScheme = instance: any (label: hasSuffix ":host" label) instance.labels;

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

  options.services.gitea-actions-runner = with types; {
    package = mkPackageOption pkgs "gitea-actions-runner" { };

    instances = mkOption {
      default = { };
      description = ''
        Gitea Actions Runner instances.
      '';
      type = attrsOf (submodule {
        options = {
          enable = mkEnableOption "Gitea Actions Runner instance";

          name = mkOption {
            type = str;
            example = literalExpression "config.networking.hostName";
            description = ''
              The name identifying the runner instance towards the Gitea/Forgejo instance.
            '';
          };

          url = mkOption {
            type = str;
            example = "https://forge.example.com";
            description = ''
              Base URL of your Gitea/Forgejo instance.
            '';
          };

          token = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              Plain token to register at the configured Gitea/Forgejo instance.
            '';
          };

          tokenFile = mkOption {
            type = nullOr (either str path);
            default = null;
            description = ''
              Path to an environment file, containing the `TOKEN` environment
              variable, that holds a token to register at the configured
              Gitea/Forgejo instance.
            '';
          };

          labels = mkOption {
            type = listOf str;
            example = literalExpression ''
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
          settings = mkOption {
            description = ''
              Configuration for `act_runner daemon`.
              See <https://gitea.com/gitea/act_runner/src/branch/main/internal/pkg/config/config.example.yaml> for an example configuration
            '';

            type = types.submodule {
              freeformType = settingsFormat.type;
            };

            default = { };
          };

          hostPackages = mkOption {
            type = listOf package;
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
            defaultText = literalExpression ''
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

  config = mkIf (cfg.instances != { }) {
    assertions = [
      {
        assertion = any tokenXorTokenFile (attrValues cfg.instances);
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
          nameValuePair "gitea-runner-${escapeSystemdPath name}" {
            inherit (instance) enable;
            description = "Gitea Actions Runner";
            wants = [ "network-online.target" ];
            after = [
              "network-online.target"
            ]
            ++ optionals (wantsDocker) [
              "docker.service"
            ]
            ++ optionals (wantsPodman) [
              "podman.service"
            ];
            wantedBy = [
              "multi-user.target"
            ];
            environment =
              optionalAttrs (instance.token != null) {
                TOKEN = "${instance.token}";
              }
              // optionalAttrs (wantsPodman) {
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
            serviceConfig = {
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
                  export LABELS_WANTED="$(echo ${escapeShellArg (concatStringsSep "\n" instance.labels)} | sort)"
                  export LABELS_CURRENT="$(cat $LABELS_FILE 2>/dev/null || echo 0)"

                  if [ ! -e "$INSTANCE_DIR/.runner" ] || [ "$LABELS_WANTED" != "$LABELS_CURRENT" ]; then
                    # remove existing registration file, so that changing the labels forces a re-registration
                    rm -v "$INSTANCE_DIR/.runner" || true

                    # perform the registration
                    ${cfg.package}/bin/act_runner register --no-interactive \
                      --instance ${escapeShellArg instance.url} \
                      --token "$TOKEN" \
                      --name ${escapeShellArg instance.name} \
                      --labels ${escapeShellArg (concatStringsSep "," instance.labels)} \
                      --config ${configFile}

                    # and write back the configured labels
                    echo "$LABELS_WANTED" > "$LABELS_FILE"
                  fi

                '')
              ];
              ExecStart = "${cfg.package}/bin/act_runner daemon --config ${configFile}";
              SupplementaryGroups =
                optionals (wantsDocker) [
                  "docker"
                ]
                ++ optionals (wantsPodman) [
                  "podman"
                ];
            }
            // optionalAttrs (instance.tokenFile != null) {
              EnvironmentFile = instance.tokenFile;
            };
          };
      in
      mapAttrs' mkRunnerService cfg.instances;
  };
}

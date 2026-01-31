let
  attributeName = "gitea-actions-runner";
  mainProgram = "act_runner";
  name = "gitea";
  prettyName = "Gitea";
  runnerPrettyName = "Gitea Actions Runner";
  srcUrl = "https://gitea.com/gitea/act_runner";
in
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
    getExe
    hasInfix
    hasSuffix
    literalExpression
    maintainers
    mapAttrs'
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    nameValuePair
    optionalAttrs
    optionals
    types
    ;

  inherit (types)
    attrsOf
    either
    listOf
    nullOr
    package
    path
    str
    submodule
    ;

  inherit (utils)
    escapeSystemdPath
    ;

  cfg = config.services.${attributeName};

  settingsFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = with maintainers; [
    hexa
    sigmasquadron
  ];

  options.services.${attributeName} = {
    package = mkPackageOption pkgs attributeName { };

    instances = mkOption {
      default = { };
      description = ''
        ${runnerPrettyName} instances.
      '';
      type = attrsOf (submodule {
        options = {
          enable = mkEnableOption "${runnerPrettyName} instance";

          name = mkOption {
            type = str;
            example = literalExpression "config.networking.hostName";
            description = ''
              The name identifying the runner instance towards the ${prettyName} instance.
            '';
          };

          url = mkOption {
            type = str;
            example = "https://forge.example.com";
            description = ''
              Base URL of your ${prettyName} instance.
            '';
          };

          token = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              Plain token to register at the configured ${prettyName} instance.
            '';
          };

          tokenFile = mkOption {
            type = nullOr (either str path);
            default = null;
            description = ''
              Path to an environment file, containing the `TOKEN` environment
              variable, that holds a token to register at the configured
              ${prettyName} instance.
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

              Many common actions require `bash`, `git` and `nodejs`, as well as a
              filesystem that follows the filesystem hierarchy standard.
            '';
          };
          settings = mkOption {
            description = ''
              Configuration for the `${mainProgram}` daemon.
              See <${srcUrl}/src/branch/main/internal/pkg/config/config.example.yaml> for an example configuration.
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
              List of packages that are available to actions when the runner
              is configured with a host execution label.
            '';
          };
        };
      });
    };
  };

  config = mkMerge [
    (mkIf (cfg.instances != { }) (
      let
        tokenXorTokenFile =
          instance:
          (instance.token == null && instance.tokenFile != null)
          || (instance.token != null && instance.tokenFile == null);

        # Check whether any runner instance label requires a container runtime.
        # Empty label strings result in the upstream defined defaultLabels, which require docker.
        hasDockerScheme =
          instance: instance.labels == [ ] || any (label: hasInfix ":docker:" label) instance.labels;
        anyWantsContainerRuntime = any hasDockerScheme (attrValues cfg.instances);

        # provide shorthands for whether container runtimes are enabled and whether host execution is possible.
        hasDocker = config.virtualisation.docker.enable;
        hasPodman = config.virtualisation.podman.enable;
        hasHostScheme = instance: any (label: hasSuffix ":host" label) instance.labels;
      in
      {
        assertions = [
          {
            assertion = any tokenXorTokenFile (attrValues cfg.instances);
            message = "${runnerPrettyName} instances may have either a `token` or a `tokenFile` configured, but not both simultaneously.";
          }
          {
            assertion = anyWantsContainerRuntime -> hasDocker || hasPodman;
            message = "At least one of the configured ${runnerPrettyName} instances require a container hypervisor, but neither Docker nor Podman are enabled.";
          }
        ];

        systemd.services =
          let
            mkRunnerService =
              id: instance:
              let
                wantsContainerRuntime = hasDockerScheme instance;
                wantsHost = hasHostScheme instance;
                wantsDocker = wantsContainerRuntime && hasDocker;
                wantsPodman = wantsContainerRuntime && hasPodman;
                configFile = settingsFormat.generate "config.yaml" instance.settings;
              in
              nameValuePair "${name}-runner-${escapeSystemdPath id}" {
                inherit (instance) enable;
                description = runnerPrettyName;
                wants = [ "network-online.target" ];
                after = [
                  "network-online.target"
                ]
                ++ optionals wantsDocker [
                  "docker.service"
                ]
                ++ optionals wantsPodman [
                  "podman.service"
                ];
                wantedBy = [
                  "multi-user.target"
                ];
                environment =
                  optionalAttrs (instance.token != null) {
                    TOKEN = "${instance.token}";
                  }
                  // optionalAttrs wantsPodman {
                    DOCKER_HOST = "unix:///run/podman/podman.sock";
                  }
                  // {
                    HOME = "/var/lib/${name}-runner/${id}";
                  };
                path =
                  with pkgs;
                  [
                    coreutils
                  ]
                  ++ optionals wantsHost instance.hostPackages;
                serviceConfig = {
                  DynamicUser = true;
                  User = "${name}-runner";
                  StateDirectory = "${name}-runner";
                  WorkingDirectory = "-/var/lib/${name}-runner/${id}";

                  # act_runner might fail when the forge is restarted during an upgrade.
                  Restart = "on-failure";
                  RestartSec = 2;

                  ExecStartPre = [
                    (pkgs.writeShellScript "${name}-register-runner-${id}" ''
                      export INSTANCE_DIR="$STATE_DIRECTORY/${id}"
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
                        ${getExe cfg.package} register --no-interactive \
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
                  ExecStart = "${getExe cfg.package} daemon --config ${configFile}";
                  SupplementaryGroups =
                    optionals wantsDocker [
                      "docker"
                    ]
                    ++ optionals wantsPodman [
                      "podman"
                    ];
                }
                // optionalAttrs (instance.tokenFile != null) {
                  EnvironmentFile = instance.tokenFile;
                };
              };
          in
          mapAttrs' mkRunnerService cfg.instances;
      }
    ))
  ];
}

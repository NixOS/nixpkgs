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
  # https://gitea.com/gitea/runner/src/tag/v0.1.5/internal/app/cmd/register.go#L93-L98
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
  meta.maintainers = pkgs.gitea-actions-runner.meta.maintainers;

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
              Path to a file containing a token to register at the configured
              Gitea/Forgejo instance.

              For backwards compatibility, the file may instead be a
              systemd-style environment file containing a `TOKEN` assignment,
              but this format is deprecated: a warning is emitted at runtime,
              and support will be removed in the future.
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
              Configuration for gitea-runner daemon.
              See <https://gitea.com/gitea/runner/src/branch/main/internal/pkg/config/config.example.yaml> for an example configuration
            '';

            type = types.submodule {
              freeformType = settingsFormat.type;

              options.cache.external_secret_file = mkOption {
                type = nullOr (either str path);
                default = null;
                description = ''
                  Path to a file containing the shared secret for an external cache server.
                '';
              };
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
            configFile =
              let
                credentialsDirectory = "/run/credentials/gitea-runner-${escapeSystemdPath name}.service";
              in
              settingsFormat.generate "config.yaml" (
                if instance.settings.cache.external_secret_file != null then
                  lib.recursiveUpdate instance.settings {
                    cache.external_secret_file = "${credentialsDirectory}/external-secret";
                  }
                else
                  instance.settings
              );
          in
          nameValuePair "gitea-runner-${escapeSystemdPath name}" {
            inherit (instance) enable;
            description = "Gitea Actions Runner";
            wants = [ "network-online.target" ];
            after = [
              "network-online.target"
            ]
            ++ optionals wantsDocker [
              "docker.socket"
            ]
            ++ optionals wantsPodman [
              "podman.socket"
            ];
            wantedBy = [
              "multi-user.target"
            ];
            environment =
              optionalAttrs wantsPodman {
                DOCKER_HOST = "unix:///run/podman/podman.sock";
              }
              // {
                HOME = "/var/lib/gitea-runner/${name}";
                INSTANCE_DIR = "/var/lib/gitea-runner/${name}";
                TOKEN_HASH_FILE = "/var/lib/gitea-runner/${name}/.token-hash";
                LABELS_FILE = "/var/lib/gitea-runner/${name}/.labels";
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
              StateDirectory = [
                "gitea-runner"
                "gitea-runner/${name}"
              ];
              WorkingDirectory = "/var/lib/gitea-runner/${name}";

              # gitea-runner might fail when gitea is restarted during upgrade.
              Restart = "on-failure";
              RestartSec = 2;

              ExecStartPre = [
                (pkgs.writeShellScript "gitea-register-runner-${name}" ''
                  # force reregistration on changed token or labels

                  if grep -q -m1 -E '^[[:space:]]*TOKEN=' "$CREDENTIALS_DIRECTORY/token"; then
                    echo "gitea-actions-runner: providing 'tokenFile' as an environment file with a TOKEN= assignment is deprecated." >&2
                    echo "please provide the raw token as the file's content instead." >&2

                    sed -n -E 's/^[[:space:]]*TOKEN=//p' "$CREDENTIALS_DIRECTORY/token" | tail -n1 > "$RUNTIME_DIRECTORY/token"
                    export TOKEN_FILE="$RUNTIME_DIRECTORY/token"
                  else
                    export TOKEN_FILE="$CREDENTIALS_DIRECTORY/token"
                  fi

                  export TOKEN_HASH_CURRENT="$(sha256sum "$TOKEN_FILE" | cut -d' ' -f1)"
                  export TOKEN_HASH_STORED="$(cat "$TOKEN_HASH_FILE" 2>/dev/null || echo "")"
                  export LABELS_WANTED="$(echo ${escapeShellArg (concatStringsSep "\n" instance.labels)} | sort)"
                  export LABELS_CURRENT="$(cat $LABELS_FILE 2>/dev/null || echo 0)"

                  if [ ! -e "$INSTANCE_DIR/.runner" ] || [ "$LABELS_WANTED" != "$LABELS_CURRENT" ] || [ "$TOKEN_HASH_CURRENT" != "$TOKEN_HASH_STORED" ]; then
                    # remove existing registration file, so that changing the token or labels forces a re-registration
                    rm -v "$INSTANCE_DIR/.runner" || true

                    # perform the registration
                    ${getExe cfg.package} register --no-interactive \
                      --instance ${escapeShellArg instance.url} \
                      --token-file "$TOKEN_FILE" \
                      --name ${escapeShellArg instance.name} \
                      --labels ${escapeShellArg (concatStringsSep "," instance.labels)} \
                      --config ${configFile}

                    # and write back the configured labels and token hash
                    printf '%s' "$TOKEN_HASH_CURRENT" > "$TOKEN_HASH_FILE"
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

              LoadCredential =
                let
                  tokenCredentialSource =
                    if instance.tokenFile != null then
                      instance.tokenFile
                    else
                      pkgs.writeText "gitea-runner-${name}-token" instance.token;
                in
                [ "token:${tokenCredentialSource}" ]
                ++ optionals (instance.settings.cache.external_secret_file != null) [
                  "external-secret:${instance.settings.cache.external_secret_file}"
                ];
              RuntimeDirectory = "gitea-runner/${name}";
              RuntimeDirectoryMode = "0700";
            };
          };
      in
      mapAttrs' mkRunnerService cfg.instances;
  };
}

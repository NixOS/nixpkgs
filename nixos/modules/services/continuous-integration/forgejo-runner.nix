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
    literalExpression
    mapAttrs'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    nameValuePair
    optionalAttrs
    optionals
    teams
    types
    ;

  inherit (utils)
    escapeSystemdPath
    ;

  cfg = config.services.forgejo.runner;

  settingsFormat = pkgs.formats.yaml { };

  # Empty label strings result in upstream default labels, which require docker.
  hasDockerScheme =
    instance: instance.labels == [ ] || any (label: hasInfix ":docker:" label) instance.labels;
  wantsContainerRuntime = any hasDockerScheme (attrValues cfg.instances);

  hasHostScheme = instance: any (label: hasSuffix ":host" label) instance.labels;

  hasDocker = config.virtualisation.docker.enable;
  hasPodman = config.virtualisation.podman.enable;
in
{
  meta.maintainers = teams.forgejo.members;

  imports = [
    (mkRenamedOptionModule [ "services" "forgejo-runner" ] [ "services" "forgejo" "runner" ])
  ];

  options.services.forgejo.runner = with types; {
    package = mkPackageOption pkgs "forgejo-runner" { };

    instances = mkOption {
      default = { };
      description = ''
        Forgejo Actions Runner instances.
      '';
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              enable = mkEnableOption "Forgejo Actions Runner instance";

              name = mkOption {
                type = str;
                example = literalExpression "config.networking.hostName";
                description = ''
                  The name identifying the runner instance towards the Forgejo instance.
                '';
                default = name;
              };

              url = mkOption {
                type = str;
                example = "https://forge.example.com";
                description = ''
                  Base URL of your Forgejo instance.
                '';
              };

              tokenFile = mkOption {
                type = nullOr (either str path);
                default = null;
                description = ''
                  Path to a file containing only the token that will be used to register
                  with the the configured Forgejo instance.
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
                  Configuration for `forgejo-runner daemon`.
                  See <https://code.forgejo.org/forgejo/runner/src/branch/main/internal/pkg/config/config.example.yaml> for an example configuration.
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
                  List of packages that are available to actions, when the runner is configured
                  with a host execution label.
                '';
              };
            };
          }
        )
      );
    };
  };

  config = mkIf (cfg.instances != { }) {
    assertions = [
      {
        assertion = wantsContainerRuntime -> hasDocker || hasPodman;
        message = "Label configuration on forgejo.runner instance requires either docker or podman.";
      }
    ];

    systemd.services =
      let
        mkRunnerInstance =
          _: instance:
          let
            escapedName = escapeSystemdPath instance.name;
            wantsContainer = hasDockerScheme instance;
            wantsHost = hasHostScheme instance;
            wantsDocker = wantsContainer && hasDocker;
            wantsPodman = wantsContainer && hasPodman;
            configFile = settingsFormat.generate "forgejo-runner-${escapedName}.yaml" instance.settings;
          in
          nameValuePair "forgejo-runner@${escapedName}" {
            overrideStrategy = "asDropin";
            inherit (instance) enable;
            wants = [
              "network-online.target"
            ]
            ++ optionals wantsDocker [ "docker.service" ]
            ++ optionals wantsPodman [ "podman.service" ];
            after = [
              "network-online.target"
            ]
            ++ optionals wantsDocker [ "docker.service" ]
            ++ optionals wantsPodman [ "podman.service" ];
            wantedBy = [ "multi-user.target" ];

            environment = optionalAttrs wantsPodman {
              DOCKER_HOST = "unix:///run/podman/podman.sock";
            };

            path = [ pkgs.coreutils ] ++ lib.optionals wantsHost instance.hostPackages;

            serviceConfig = {
              MemoryDenyWriteExecute = !wantsHost;

              LoadCredential = [ "TOKEN:${instance.tokenFile}" ];

              ExecStartPre = [
                (lib.getExe (
                  pkgs.writeShellApplication {
                    name = "forgejo-register-runner-${escapedName}";
                    text = ''
                      INSTANCE_DIR="$STATE_DIRECTORY"
                      mkdir -vp "$INSTANCE_DIR"
                      cd "$INSTANCE_DIR"

                      LABELS_FILE="$INSTANCE_DIR/.labels.sha256"
                      LABELS_WANTED="$(echo ${escapeShellArg (concatStringsSep "\n" instance.labels)} | sort)"
                      LABELS_WANTED_HASH="$(printf '%s' "$LABELS_WANTED" | sha256sum | cut -d' ' -f1)"
                      LABELS_CURRENT_HASH="$(cat "$LABELS_FILE" 2>/dev/null || true)"

                      if [ ! -e "$INSTANCE_DIR/.runner" ] || [ "$LABELS_WANTED_HASH" != "$LABELS_CURRENT_HASH" ]; then
                        rm -vf "$INSTANCE_DIR/.runner" || true

                        ${cfg.package}/bin/forgejo-runner register \
                          --no-interactive \
                          --instance ${escapeShellArg instance.url} \
                          --token "$(cat "$CREDENTIALS_DIRECTORY/TOKEN")" \
                          --name ${escapeShellArg instance.name} \
                          --labels ${escapeShellArg (concatStringsSep "," instance.labels)} \
                          --config ${configFile}

                        printf '%s' "$LABELS_WANTED_HASH" > "$LABELS_FILE"
                      fi
                    '';
                  }
                ))
              ];
              ExecStart = lib.mkForce "${cfg.package}/bin/forgejo-runner daemon --config ${configFile}";
              SupplementaryGroups = optionals wantsDocker [ "docker" ] ++ optionals wantsPodman [ "podman" ];
              ExecPaths = lib.optionals wantsHost [ "/var/lib/forgejo-runner/${escapedName}" ];
            };
          };
      in
      {
        "forgejo-runner@" = {
          description = "Forgejo Actions Runner (%I)";

          environment = {
            HOME = "/var/lib/forgejo-runner/%i";
          };

          serviceConfig = {
            DynamicUser = true;
            User = "forgejo-runner-%i";
            StateDirectory = "forgejo-runner/%i";
            WorkingDirectory = "/var/lib/forgejo-runner/%i";

            Restart = "on-failure";
            RestartSec = 2;

            AmbientCapabilities = "";
            CapabilityBoundingSet = "";
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            ProcSubset = "pid";
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            RemoveIPC = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [ "@system-service" ];
            UMask = "0077";
          };
        };
      }
      // mapAttrs' mkRunnerInstance cfg.instances;
  };
}

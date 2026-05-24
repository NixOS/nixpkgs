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

  instanceLabels =
    instance:
    (lib.defaultTo [ ] instance.labels)
    ++ lib.concatMap (connection: lib.defaultTo [ ] (connection.labels or [ ])) (
      lib.attrValues (instance.settings.server.connections or { })
    );

  hasDockerScheme = labels: any (label: hasInfix ":docker:" label) labels;
  hasHostScheme = labels: any (label: hasSuffix ":host" label) labels;

  hasDocker = config.virtualisation.docker.enable;
  hasPodman = config.virtualisation.podman.enable;

  labelsOption = mkOption {
    type = types.nullOr (types.listOf types.str);
    default = null;
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
  urlOption = mkOption {
    type = types.nullOr types.str;
    default = null;
    example = "https://forge.example.com";
    description = ''
      Base URL of your Forgejo instance.

      Can also be specified in `settings.servier.connections`
    '';
  };

  mkRunnerInstance =
    name: instance:
    let
      allLabels = instanceLabels instance;
      wantsContainer = hasDockerScheme allLabels;
      wantsHost = hasHostScheme allLabels;
      wantsDocker = wantsContainer && hasDocker;
      wantsPodman = wantsContainer && hasPodman;
      configFile = settingsFormat.generate "forgejo-runner-${name}.yaml" instance.settings;
    in
    nameValuePair "forgejo-runner-${escapeSystemdPath name}" {
      inherit (instance) enable;

      description = "Forgejo Actions Runner (${name})";

      environment = {
        HOME = "/var/lib/forgejo-runner/${name}";
      }
      // optionalAttrs wantsPodman {
        DOCKER_HOST = "unix:///run/podman/podman.sock";
      };

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

      path = [ pkgs.coreutils ] ++ lib.optionals wantsHost instance.hostPackages;

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "forgejo-runner/${name}";
        WorkingDirectory = "/var/lib/forgejo-runner/${name}";

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
        MemoryDenyWriteExecute = !wantsHost;

        LoadCredential =
          lib.optionals (instance.registrationTokenFile != null) [
            "REGISTRATION_TOKEN:${instance.registrationTokenFile}"
          ]
          ++ lib.mapAttrsToList (name: value: "${name}:${value}") instance.credentials;

        SupplementaryGroups = optionals wantsDocker [ "docker" ] ++ optionals wantsPodman [ "podman" ];
        ExecPaths = lib.optionals wantsHost [ "/var/lib/forgejo-runner/${name}" ];

        ExecStartPre = lib.optionals (instance.registrationTokenFile != null) [
          (lib.getExe (
            pkgs.writeShellApplication {
              name = "forgejo-register-runner-${name}";
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
                    --token "$(cat "$CREDENTIALS_DIRECTORY/REGISTRATION_TOKEN")" \
                    --name ${escapeShellArg name} \
                    --labels ${escapeShellArg (concatStringsSep "," instance.labels)} \
                    --config ${configFile}

                  printf '%s' "$LABELS_WANTED_HASH" > "$LABELS_FILE"
                fi
              '';
            }
          ))
        ];

        ExecStart = lib.mkForce "${cfg.package}/bin/forgejo-runner daemon --config '${configFile}'";
      };
    };
in
{
  meta.maintainers = teams.forgejo.members;

  options.services.forgejo.runner = with types; {
    package = mkPackageOption pkgs "forgejo-runner" { };

    instances = mkOption {
      default = { };
      description = ''
        Forgejo Actions Runner instances.
      '';
      type = attrsOf (submodule {
        options = {
          labels = labelsOption;
          enable = mkEnableOption "Forgejo Actions Runner instance";

          url = urlOption;

          registrationTokenFile = mkOption {
            type = types.nullOr (types.either types.str types.path);
            default = null;
            description = ''
              Path to a file containing only the token that will be used to register
              on start with the the configured Forgejo instance.

              **Deprecated** Replaced by `settings.server.connections`

              <https://forgejo.org/docs/latest/admin/actions/registration/>
            '';
          };

          credentials = mkOption {
            type = types.attrsOf types.path;
            default = { };
            example = {
              WORKER1_TOKEN = "/run/keys/worker1";
            };
            description = ''
              Environment variables with absolute paths to credentials files to load
              on runner startup.

              Use with Forgejo v15+ pre-registered server connections:

              `settings.server.connections.<connection>.token_url = "file:$CREDENTIALS_DIRECTORY/WORKER1_TOKEN"`
            '';
          };

          settings = mkOption {
            description = ''
              Configuration for `forgejo-runner daemon`.
              See <https://code.forgejo.org/forgejo/runner/src/branch/main/internal/pkg/config/config.example.yaml> for an example configuration.
            '';

            type = types.submodule {
              freeformType = settingsFormat.type;

              options.server.connections = mkOption {
                type = types.attrsOf (
                  types.submodule {
                    freeformType = settingsFormat.type;
                    options = {
                      url = urlOption;
                      labels = labelsOption;
                      token_url = mkOption {
                        type = types.pathWith { inStore = false; };
                        description = ''
                          Path to the Forgejo v15+ pre-registered runner token.
                          Supports a single placeholder: `$CREDENTIALS_DIRECTORY`

                          Can be combined with `instances.<instance>.credentails`

                          <https://forgejo.org/docs/latest/admin/actions/registration/>
                        '';
                      };
                      uuid = mkOption {
                        type = types.str;
                        description = ''
                          UUID of runner provided by Forgejo server during pre-registration.

                          <https://forgejo.org/docs/latest/admin/actions/registration/>
                        '';
                      };
                    };
                  }
                );
                default = { };
                description = ''
                  Forgejo v15+ pre-registered server connections.

                  See <https://forgejo.org/docs/latest/admin/actions/registration>
                '';
                example = literalExpression ''
                  {
                    worker1 = {
                      url = "https://forgejo.mine";
                      uuid = "4708f0f2-4185-49b4-8552-bc7261ec26aa";
                      token_url = "file:$CREDENTIALS_DIRECTORY/WORKER1_TOKEN";
                      labels = [
                        "debian:docker://docker.io/library/node:lts"
                        "local/x86_64-linux:host"
                      ];
                    };
                  };
                '';
              };

            };

            default = { };
          };

          hostPackages = mkOption {
            type = types.listOf types.package;
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
      });
    };
  };

  config = mkIf (cfg.instances != { }) {
    assertions = lib.foldlAttrs (
      acc_inst: name_inst: instance:
      (lib.foldlAttrs (
        acc_conn: name: connection:
        acc_conn
        ++ [
          {
            assertion = connection.url != null;
            message = "forgejo.runner.instances.${name_inst}.settings.server.connections.${name} requires `url` to be set.";
          }
          {
            assertion = !(connection ? token);
            message = "forgejo.runner.instances.${name_inst}.settings.server.connections.${name}.token cannot be used, use token_url instead.";
          }
        ]
      ) acc_inst instance.settings.server.connections)
      ++ [
        {
          assertion =
            instance.settings.server.connections != { }
            -> instance.registrationTokenFile == null && instance.url == null && instance.labels == null;
          message = "forgejo.runner.instances.${name_inst} cannot contain both url/registrationTokenFile and settings.server.connections";
        }
        {
          assertion = instance.registrationTokenFile != null -> instance.url != null;
          message = "forgejo.runner.instances.${name_inst}.registrationTokenFile requires `url` to be set.";
        }
        {
          assertion = instance.labels != null -> instance.registrationTokenFile != null;
          message = "forgejo.runner.instances.${name_inst}.labels requires `registrationTokenFile` to be set.";
        }
        {
          assertion = hasDockerScheme (instanceLabels instance) -> hasDocker || hasPodman;
          message = "forgejo.runner.instances.${name_inst} label configuration requires either docker or podman.";
        }
      ]
    ) [ ] cfg.instances;

    systemd.services = mapAttrs' mkRunnerInstance cfg.instances;
  };
}

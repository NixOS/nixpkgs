{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    all
    any
    attrByPath
    attrValues
    concatLists
    filterAttrs
    hasInfix
    hasSuffix
    literalExpression
    mapAttrs
    mapAttrs'
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    nameValuePair
    optionalAttrs
    optionals
    recursiveUpdate
    types
    ;

  inherit (utils) escapeSystemdPath;

  cfg = config.services.forgejo-runner;

  settingsFormat = pkgs.formats.yaml { };

  enabledInstances = filterAttrs (_: instance: instance.enable) cfg.instances;

  credentialName = connectionName: "${escapeSystemdPath connectionName}-token";

  runnerLabels =
    instance:
    let
      labels =
        attrByPath
          [
            "runner"
            "labels"
          ]
          [ ]
          instance.settings;
    in
    if builtins.isList labels then labels else [ ];

  connectionLabels =
    instance: concatLists (mapAttrsToList (_: connection: connection.labels) instance.connections);

  instanceLabels = instance: runnerLabels instance ++ connectionLabels instance;

  hasDockerScheme = instance: any (label: hasInfix ":docker://" label) (instanceLabels instance);

  hasHostScheme = instance: any (label: hasSuffix ":host" label) (instanceLabels instance);

  hasDocker = config.virtualisation.docker.enable;
  hasPodman = config.virtualisation.podman.enable;

  wantsContainerRuntime = any hasDockerScheme (attrValues enabledInstances);

  tokenXorTokenFile =
    connection:
    (connection.token == null && connection.tokenFile != null)
    || (connection.token != null && connection.tokenFile == null);

  serverConnectionsInSettings =
    instance:
    let
      server = instance.settings.server or { };
    in
    builtins.isAttrs server && server ? connections;

  allConnections = concatLists (
    mapAttrsToList (
      instanceName: instance:
      mapAttrsToList (connectionName: connection: {
        inherit
          instanceName
          connectionName
          connection
          ;
      }) instance.connections
    ) enabledInstances
  );

  mkConnectionSettings =
    connectionName: connection:
    {
      inherit (connection) url uuid;
    }
    // optionalAttrs (connection.labels != [ ]) {
      inherit (connection) labels;
    }
    // optionalAttrs (connection.fetchInterval != null) {
      fetch_interval = connection.fetchInterval;
    }
    // optionalAttrs (connection.token != null) {
      inherit (connection) token;
    }
    // optionalAttrs (connection.tokenFile != null) {
      token_url = "file:$CREDENTIALS_DIRECTORY/${credentialName connectionName}";
    };
in
{
  meta.maintainers = lib.teams.forgejo.members;

  options.services.forgejo-runner = with types; {
    package = mkPackageOption pkgs "forgejo-runner" { };

    instances = mkOption {
      default = { };
      description = ''
        Forgejo Runner instances.
      '';
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              enable = mkEnableOption "Forgejo Runner instance";

              settings = mkOption {
                description = ''
                  Configuration for `forgejo-runner daemon`.

                  The `server.connections` section is generated from the
                  [](#opt-services.forgejo-runner.instances._name_.connections)
                  option.

                  See <https://code.forgejo.org/forgejo/runner/src/branch/main/internal/pkg/config/config.example.yaml>
                  for an example configuration.
                '';
                type = submodule {
                  freeformType = settingsFormat.type;
                };
                default = {
                  runner.name = name;
                };
                defaultText = literalExpression ''
                  {
                    runner.name = "<instance name>";
                  }
                '';
                example = literalExpression ''
                  {
                    log.level = "info";
                    runner.capacity = 2;
                    container.network = "bridge";
                    cache.enabled = true;
                  }
                '';
              };

              connections = mkOption {
                default = { };
                description = ''
                  Forgejo server connections for this runner instance.
                '';
                type = attrsOf (submodule {
                  options = {
                    url = mkOption {
                      type = str;
                      example = "https://codeberg.org/";
                      description = ''
                        Base URL of the Forgejo instance.
                      '';
                    };

                    uuid = mkOption {
                      type = str;
                      example = "33834eef-e758-48c4-a676-1745426747aa";
                      description = ''
                        UUID identifying this runner towards the Forgejo instance.
                      '';
                    };

                    token = mkOption {
                      type = nullOr str;
                      default = null;
                      description = ''
                        Plain runner token for this connection.

                        This is copied into the Nix store. Use
                        [](#opt-services.forgejo-runner.instances._name_.connections._name_.tokenFile)
                        for secrets.
                      '';
                    };

                    tokenFile = mkOption {
                      type = nullOr (either str path);
                      default = null;
                      description = ''
                        Path to a file containing the runner token for this connection.
                        The file is passed to the service with `LoadCredential`.
                      '';
                    };

                    labels = mkOption {
                      type = listOf str;
                      default = [ ];
                      example = literalExpression ''
                        [
                          "debian-latest:docker://node:22-bookworm"
                          "ubuntu-latest:docker://node:22-bookworm"
                          "native:host"
                        ]
                      '';
                      description = ''
                        Labels used to map jobs to their runtime environment.

                        If empty, the runner falls back to labels declared in
                        `settings.runner.labels`.
                      '';
                    };

                    fetchInterval = mkOption {
                      type = nullOr str;
                      default = null;
                      example = "30s";
                      description = ''
                        How often Forgejo Runner should ask this connection for pending jobs.
                      '';
                    };
                  };
                });
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
                  Packages available to actions when this runner has a host execution label.
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
        assertion = all (instance: !instance.enable || instance.connections != { }) (
          attrValues cfg.instances
        );
        message = "Enabled instances of forgejo-runner must define at least one connection.";
      }
      {
        assertion = all ({ connection, ... }: tokenXorTokenFile connection) allConnections;
        message = "Connections of forgejo-runner instances must have `token` or `tokenFile`, not both.";
      }
      {
        assertion = all (instance: !serverConnectionsInSettings instance) (attrValues enabledInstances);
        message = "Configure Forgejo Runner server connections with `services.forgejo-runner.instances.<name>.connections`, not `settings.server.connections`.";
      }
      {
        assertion = wantsContainerRuntime -> hasDocker || hasPodman;
        message = "Docker labels on forgejo-runner instances require either Docker or Podman.";
      }
    ];

    systemd.services =
      let
        mkRunnerService =
          name: instance:
          let
            wantsDockerScheme = hasDockerScheme instance;
            wantsHost = hasHostScheme instance;
            wantsDocker = wantsDockerScheme && hasDocker;
            wantsPodman = wantsDockerScheme && hasPodman;
            settings = recursiveUpdate instance.settings {
              server.connections = mapAttrs mkConnectionSettings instance.connections;
            };
            configFile = settingsFormat.generate "forgejo-runner-${name}.yaml" settings;
          in
          nameValuePair "forgejo-runner-${escapeSystemdPath name}" {
            inherit (instance) enable;
            description = "Forgejo Runner";
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
            wantedBy = [ "multi-user.target" ];
            environment =
              optionalAttrs wantsPodman {
                DOCKER_HOST = "unix:///run/podman/podman.sock";
              }
              // {
                HOME = "/var/lib/forgejo-runner/${name}";
              };
            path = [
              pkgs.coreutils
            ]
            ++ optionals wantsHost instance.hostPackages;
            serviceConfig = {
              DynamicUser = true;
              User = "forgejo-runner";
              StateDirectory = "forgejo-runner";
              WorkingDirectory = "-/var/lib/forgejo-runner/${name}";

              Restart = "on-failure";
              RestartSec = 2;

              ExecStart = "${cfg.package}/bin/forgejo-runner daemon --config ${configFile}";
              SupplementaryGroups =
                optionals wantsDocker [
                  "docker"
                ]
                ++ optionals wantsPodman [
                  "podman"
                ];
            }
            //
              optionalAttrs (any (connection: connection.tokenFile != null) (attrValues instance.connections))
                {
                  LoadCredential = mapAttrsToList (
                    connectionName: connection: "${credentialName connectionName}:${connection.tokenFile}"
                  ) (filterAttrs (_: connection: connection.tokenFile != null) instance.connections);
                };
          };
      in
      mapAttrs' mkRunnerService enabledInstances;
  };
}

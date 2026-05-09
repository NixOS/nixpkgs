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
    getExe
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
    mapAttrsToList (_: instance: attrValues instance.connections) enabledInstances
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

  connectionOptions = {
    options = {
      url = mkOption {
        type = types.str;
        example = "https://codeberg.org/";
        description = ''
          Base URL of the Forgejo instance.
        '';
      };

      uuid = mkOption {
        type = types.str;
        example = "33834eef-e758-48c4-a676-1745426747aa";
        description = ''
          UUID identifying this runner towards the Forgejo instance.
        '';
      };

      token = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Plain runner token for this connection.

          This is copied into the Nix store. Use
          [](#opt-services.forgejo-runner.instances._name_.connections._name_.tokenFile)
          for secrets.
        '';
      };

      tokenFile = mkOption {
        type = types.nullOr (types.either types.str types.path);
        default = null;
        description = ''
          Path to a file containing the runner token for this connection.
          The file is passed to the service with `LoadCredential`.
        '';
      };

      labels = mkOption {
        type = types.listOf types.str;
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
        type = types.nullOr types.str;
        default = null;
        example = "30s";
        description = ''
          How often Forgejo Runner should ask this connection for pending jobs.
        '';
      };
    };
  };

  instanceOptions =
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
          type = types.submodule {
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
          type = types.attrsOf (types.submodule connectionOptions);
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
            Packages available to actions when this runner has a host execution label.
          '';
        };
      };
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
      type = attrsOf (submodule instanceOptions);
    };
  };

  config = mkIf (enabledInstances != { }) {
    assertions = [
      {
        assertion = all (instance: !instance.enable || instance.connections != { }) (
          attrValues cfg.instances
        );
        message = "Enabled instances of forgejo-runner must define at least one connection.";
      }
      {
        assertion = all tokenXorTokenFile allConnections;
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
            escapedName = escapeSystemdPath name;
            wantsDockerScheme = hasDockerScheme instance;
            wantsHost = hasHostScheme instance;
            wantsDocker = wantsDockerScheme && hasDocker;
            wantsPodman = wantsDockerScheme && hasPodman;
            settings = recursiveUpdate instance.settings {
              server.connections = mapAttrs mkConnectionSettings instance.connections;
            };
            configFile = settingsFormat.generate "forgejo-runner-${name}.yaml" settings;
          in
          nameValuePair "forgejo-runner-${escapedName}" {
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
                HOME = "/var/lib/forgejo-runner/${escapedName}";
              };
            path = [
              pkgs.coreutils
            ]
            ++ optionals wantsHost instance.hostPackages;
            serviceConfig = {
              DynamicUser = true;
              User = "forgejo-runner";
              StateDirectory = "forgejo-runner/${escapedName}";
              WorkingDirectory = "-/var/lib/forgejo-runner/${escapedName}";

              Restart = "on-failure";
              RestartSec = 2;

              ExecStart = "${getExe cfg.package} daemon --config ${configFile}";
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

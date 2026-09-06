{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tdarr;
  enabledNodes = lib.filterAttrs (_: nodeCfg: nodeCfg.enable) cfg.nodes;
  nodesEnabled = cfg.enable || (enabledNodes != { });
  serverEnabled = cfg.enable || cfg.server.enable;
  nodeConfigFiles = lib.mapAttrs (
    nodeId: nodeCfg:
    pkgs.writeText "Tdarr_Node_Config_${nodeId}.json" (
      builtins.toJSON { pathTranslators = nodeCfg.pathTranslators; }
    )
  ) enabledNodes;
in
{
  options.services.tdarr.nodes = lib.mkOption {
    default = { };
    description = "Attribute set of Tdarr processing nodes to run on this machine.";
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            enable = lib.mkEnableOption "this Tdarr node" // {
              default = true;
            };

            package = lib.mkOption {
              type = lib.types.package;
              default = cfg.package.node;
              defaultText = lib.literalExpression "config.services.tdarr.package.node";
              description = "Package to use for this Tdarr node.";
            };

            name = lib.mkOption {
              type = lib.types.str;
              default = "${config.networking.hostName}-${name}";
              defaultText = lib.literalExpression ''"''${config.networking.hostName}-''${name}"'';
              description = "Display name for this node in the Tdarr web UI.";
            };

            dataDir = lib.mkOption {
              type = lib.types.path;
              default = "${cfg.dataDir}/nodes/${name}";
              defaultText = lib.literalExpression ''"''${config.services.tdarr.dataDir}/nodes/''${name}"'';
              description = "Data directory for this node.";
            };

            serverURL = lib.mkOption {
              type = lib.types.str;
              default = "http://127.0.0.1:${toString cfg.server.serverPort}";
              defaultText = lib.literalExpression ''"http://127.0.0.1:''${toString config.services.tdarr.server.serverPort}"'';
              description = ''
                Full URL of the Tdarr server this node connects to.

                This is the recommended way to specify the server location.
                When running a local server, the default value is correct.
              '';
            };

            type = lib.mkOption {
              type = lib.types.enum [
                "mapped"
                "unmapped"
              ];
              default = "mapped";
              description = ''
                Node type.

                - `mapped`: Node accesses files directly from the library paths.
                - `unmapped`: Node receives files over the network API.
              '';
            };

            priority = lib.mkOption {
              type = lib.types.int;
              default = -1;
              description = ''
                Node priority for job assignment.

                `-1` means no priority. `0` is the highest priority, `1` is next, and so on.
              '';
            };

            pollInterval = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 2000;
              description = "How often the node checks the server for work, in milliseconds.";
            };

            startPaused = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the node starts in a paused state.";
            };

            maxLogSizeMB = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 10;
              description = "Maximum log file size in megabytes.";
            };

            cronPluginUpdate = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Cron expression for automatic plugin updates. Empty string disables.";
            };

            pathTranslators = lib.mkOption {
              type = lib.types.listOf (
                lib.types.submodule {
                  options = {
                    server = lib.mkOption {
                      type = lib.types.str;
                      description = "Server-side path for path translation.";
                    };
                    node = lib.mkOption {
                      type = lib.types.str;
                      description = "Node-side path for path translation.";
                    };
                  };
                }
              );
              default = [ ];
              description = ''
                Path translations between server and node for cross-platform or
                cross-mount-point file access.
              '';
              example = lib.literalExpression ''
                [
                  { server = "/media"; node = "/mnt/media"; }
                  { server = "/cache"; node = "/mnt/cache"; }
                ]
              '';
            };

            workers = {
              transcodeGPU = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 0;
                description = "Number of GPU transcode workers. Can be overridden in the web UI.";
              };
              transcodeCPU = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 2;
                description = "Number of CPU transcode workers. Can be overridden in the web UI.";
              };
              healthcheckGPU = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 0;
                description = "Number of GPU healthcheck workers. Can be overridden in the web UI.";
              };
              healthcheckCPU = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 1;
                description = "Number of CPU healthcheck workers. Can be overridden in the web UI.";
              };
            };

            environmentFile = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              description = ''
                File containing environment variable overrides for this node,
                in the format accepted by systemd's `EnvironmentFile`.

                Useful for passing secrets like `apiKey` without putting them
                in the Nix store.
              '';
              example = "/run/secrets/tdarr-node-env";
            };
          };
        }
      )
    );
  };

  config = lib.mkIf nodesEnabled {
    systemd.tmpfiles.rules = lib.concatMap (nodeId: [
      "d ${cfg.dataDir}/nodes/${nodeId} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/nodes/${nodeId}/configs 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/nodes/${nodeId}/logs 0750 ${cfg.user} ${cfg.group} -"
      "L+ ${cfg.dataDir}/nodes/${nodeId}/configs/Tdarr_Node_Config.json - - - - ${nodeConfigFiles.${nodeId}}"
    ]) (builtins.attrNames enabledNodes);

    systemd.services = lib.mapAttrs' (
      nodeId: nodeCfg:
      lib.nameValuePair "tdarr-node-${nodeId}" {
        description = "Tdarr Node - ${nodeCfg.name}";
        after = [ "network.target" ] ++ lib.optionals serverEnabled [ "tdarr-server.service" ];
        wants = lib.optionals serverEnabled [ "tdarr-server.service" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          nodeName = nodeCfg.name;
          serverURL = nodeCfg.serverURL;
          nodeType = nodeCfg.type;
          priority = toString nodeCfg.priority;
          cronPluginUpdate = nodeCfg.cronPluginUpdate;
          maxLogSizeMB = toString nodeCfg.maxLogSizeMB;
          pollInterval = toString nodeCfg.pollInterval;
          startPaused = lib.boolToString nodeCfg.startPaused;
          transcodegpuWorkers = toString nodeCfg.workers.transcodeGPU;
          transcodecpuWorkers = toString nodeCfg.workers.transcodeCPU;
          healthcheckgpuWorkers = toString nodeCfg.workers.healthcheckGPU;
          healthcheckcpuWorkers = toString nodeCfg.workers.healthcheckCPU;
          rootDataPath = toString nodeCfg.dataDir;
        };
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart = lib.getExe nodeCfg.package;
          Restart = "on-failure";
          RestartSec = 5;
          WorkingDirectory = toString nodeCfg.dataDir;

          # Hardening
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          StateDirectory = lib.mkIf (lib.hasPrefix "/var/lib/" (toString nodeCfg.dataDir)) (
            let
              rel = lib.removePrefix "/var/lib/" (toString nodeCfg.dataDir);
            in
            "${rel} ${rel}/configs ${rel}/logs"
          );
          StateDirectoryMode = lib.mkIf (lib.hasPrefix "/var/lib/" (toString nodeCfg.dataDir)) "0750";
          ReadWritePaths = lib.optionals (!lib.hasPrefix "/var/lib/" (toString nodeCfg.dataDir)) [
            (toString nodeCfg.dataDir)
          ];
        }
        // lib.optionalAttrs (nodeCfg.environmentFile != null) {
          EnvironmentFile = nodeCfg.environmentFile;
        };
      }
    ) enabledNodes;
  };
}

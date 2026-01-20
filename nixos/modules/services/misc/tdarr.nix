{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tdarr;

  # Function to generate the node-specific configuration
  mkNodeConfig =
    name: nodeCfg:
    {
      nodeName = nodeCfg.name;
      serverURL = "http://${cfg.serverIP}:${toString cfg.serverPort}";
      serverIP = cfg.serverIP;
      serverPort = cfg.serverPort;
      pathTranslators = nodeCfg.pathTranslators;
      nodeType = nodeCfg.type;
      unmappedNodeCache =
        if nodeCfg.unmappedCache != "" then nodeCfg.unmappedCache else "${nodeCfg.dataDir}/cache";
      priority = nodeCfg.priority;
      cronPluginUpdate = cfg.cronPluginUpdate;
      apiKey = cfg.auth.apiKey;
      maxLogSizeMB = cfg.maxLogSizeMB;
      pollInterval = nodeCfg.pollInterval;
      startPaused = nodeCfg.startPaused;
      transcodegpuWorkers = nodeCfg.workers.transcodeGPU;
      transcodecpuWorkers = nodeCfg.workers.transcodeCPU;
      healthcheckgpuWorkers = nodeCfg.workers.healthcheckGPU;
      healthcheckcpuWorkers = nodeCfg.workers.healthcheckCPU;
    }
    // cfg.extraNodeConfig;

  serverDataDir = "${cfg.dataDir}/server";

  # Filter enabled nodes
  enabledNodes = filterAttrs (_: nodeCfg: nodeCfg.enable) cfg.nodes;

in
{
  options.services.tdarr = {
    enable = mkEnableOption "Tdarr distributed transcoding system";

    package = mkOption {
      type = types.package;
      default = pkgs.tdarr;
      defaultText = lib.literalExpression "pkgs.tdarr";
      description = "Tdarr package to use";
    };

    serverPort = mkOption {
      type = types.port;
      default = 8266;
      description = "Tdarr server API port";
    };

    webUIPort = mkOption {
      type = types.port;
      default = 8265;
      description = "Tdarr web UI port";
    };

    serverIP = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Server bind address";
    };

    serverDualStack = mkOption {
      type = types.bool;
      default = false;
      description = "Enable IPv4/IPv6 dual-stack networking";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/tdarr";
      description = "Base directory for Tdarr data";
    };

    enableCCExtractor = mkOption {
      type = types.bool;
      default = false;
      description = "Enable CCExtractor for closed caption extraction";
    };

    maxLogSizeMB = mkOption {
      type = types.int;
      default = 10;
      description = "Maximum log file size in MB";
    };

    allowUnmappedNodes = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Allow unmapped nodes to connect. When enabled, files will be accessible
        through the network API. Authentication is strongly recommended when enabled.
      '';
    };

    cronPluginUpdate = mkOption {
      type = types.str;
      default = "";
      description = "Cron expression for automatic plugin updates (empty to disable)";
    };

    auth = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable authentication";
      };
      secretKey = mkOption {
        type = types.str;
        default = "";
        description = "Secret key for authentication";
      };
      apiKey = mkOption {
        type = types.str;
        default = "";
        description = "API key for node authentication";
      };
    };

    nodes = mkOption {
      default = { };
      description = "Attribute set of Tdarr nodes to run on this machine.";
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              enable = mkEnableOption "this Tdarr node" // {
                default = true;
              };
              name = mkOption {
                type = types.str;
                default = "${config.networking.hostName}-${name}";
                defaultText = lib.literalExpression ''"''${config.networking.hostName}-${name}"'';
                description = "Name for this specific Tdarr node";
              };
              dataDir = mkOption {
                type = types.path;
                default = "${cfg.dataDir}/nodes/${name}";
                defaultText = lib.literalExpression ''"''${config.services.tdarr.dataDir}/nodes/${name}"'';
                description = "Specific data directory for this node";
              };
              type = mkOption {
                type = types.enum [
                  "mapped"
                  "unmapped"
                ];
                default = "mapped";
                description = "Node type - mapped or unmapped";
              };
              unmappedCache = mkOption {
                type = types.str;
                default = "";
                description = "Path for unmapped node cache";
              };
              priority = mkOption {
                type = types.int;
                default = -1;
                description = "Node priority";
              };
              pollInterval = mkOption {
                type = types.int;
                default = 2000;
                description = "Polling interval in ms";
              };
              startPaused = mkOption {
                type = types.bool;
                default = false;
                description = "Start node in paused state";
              };
              pathTranslators = mkOption {
                type = types.listOf (
                  types.submodule {
                    options = {
                      server = mkOption {
                        type = types.str;
                        description = "Server-side path for path translation";
                      };
                      node = mkOption {
                        type = types.str;
                        description = "Node-side path for path translation";
                      };
                    };
                  }
                );
                default = [ ];
                description = "Path translations between server and node";
              };
              workers = {
                transcodeGPU = mkOption {
                  type = types.int;
                  default = 0;
                  description = "Number of GPU transcode workers";
                };
                transcodeCPU = mkOption {
                  type = types.int;
                  default = 2;
                  description = "Number of CPU transcode workers";
                };
                healthcheckGPU = mkOption {
                  type = types.int;
                  default = 0;
                  description = "Number of GPU healthcheck workers";
                };
                healthcheckCPU = mkOption {
                  type = types.int;
                  default = 1;
                  description = "Number of CPU healthcheck workers";
                };
              };
            };
          }
        )
      );
    };

    extraServerConfig = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra configuration options for the Tdarr server";
    };

    extraNodeConfig = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra configuration options for Tdarr nodes";
    };

    user = mkOption {
      type = types.str;
      default = "tdarr";
      description = "User account under which Tdarr runs";
    };

    group = mkOption {
      type = types.str;
      default = "tdarr";
      description = "Group account under which Tdarr runs";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for Tdarr";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups.${cfg.group} = { };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/server 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/server/configs 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/nodes 0750 ${cfg.user} ${cfg.group} -"
    ]
    ++ (mapAttrsToList (
      nodeId: _: "d ${cfg.dataDir}/nodes/${nodeId} 0750 ${cfg.user} ${cfg.group} -"
    ) enabledNodes)
    ++ (mapAttrsToList (
      nodeId: _: "d ${cfg.dataDir}/nodes/${nodeId}/configs 0750 ${cfg.user} ${cfg.group} -"
    ) enabledNodes);

    systemd.services = {
      tdarr-server = {
        description = "Tdarr Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment.rootDataPath = toString serverDataDir;
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStartPre = pkgs.writeShellScript "tdarr-server-pre" ''
            ${pkgs.coreutils}/bin/install -m 644 ${
              pkgs.writeText "Tdarr_Server_Config.json" (
                builtins.toJSON (
                  {
                    serverPort = cfg.serverPort;
                    webUIPort = cfg.webUIPort;
                    serverIP = cfg.serverIP;
                    serverBindIP = false;
                    serverDualStack = cfg.serverDualStack;
                    # Paths are handled by the wrapper, not needed in config
                    openBrowser = false;
                    auth = cfg.auth.enable;
                    authSecretKey = cfg.auth.secretKey;
                    maxLogSizeMB = cfg.maxLogSizeMB;
                    allowUnmappedNodes = cfg.allowUnmappedNodes;
                    cronPluginUpdate = cfg.cronPluginUpdate;
                  }
                  // cfg.extraServerConfig
                )
              )
            } ${serverDataDir}/configs/Tdarr_Server_Config.json
          '';
          ExecStart = "${cfg.package}/bin/tdarr-server";
          ReadWritePaths = [ cfg.dataDir ];
          Restart = "on-failure";
        };
      };
    }
    // (mapAttrs' (
      nodeId: nodeCfg:
      nameValuePair "tdarr-node-${nodeId}" {
        description = "Tdarr Node - ${nodeCfg.name}";
        after = [
          "network.target"
          "tdarr-server.service"
        ];
        wants = [ "tdarr-server.service" ];
        wantedBy = [ "multi-user.target" ];
        environment.rootDataPath = toString nodeCfg.dataDir;
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStartPre = pkgs.writeShellScript "tdarr-node-${nodeId}-pre" ''
            ${pkgs.coreutils}/bin/install -m 644 ${pkgs.writeText "Tdarr_Node_Config_${nodeId}.json" (builtins.toJSON (mkNodeConfig nodeId nodeCfg))} ${toString nodeCfg.dataDir}/configs/Tdarr_Node_Config.json
          '';
          ExecStart = "${cfg.package}/bin/tdarr-node";
          ReadWritePaths = [ cfg.dataDir ];
          Restart = "on-failure";
        };
      }
    ) enabledNodes);

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      cfg.serverPort
      cfg.webUIPort
    ];
  };

  meta = {
    maintainers = with maintainers; [ mistyttm ];
    doc = ./tdarr.md;
  };
}

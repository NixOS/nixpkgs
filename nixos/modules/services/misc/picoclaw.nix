{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.picoclaw;
  configFormat = pkgs.formats.json { };
  configFile = configFormat.generate "picoclaw-config.json" {
    agents.defaults = {
      workspace = cfg.workspaceDir;
      restrict_to_workspace = cfg.restrictToWorkspace;
      model_name = cfg.modelName;
      model_fallbacks = cfg.modelFallbacks;
      max_tokens = cfg.maxTokens;
      temperature = cfg.temperature;
      max_tool_iterations = cfg.maxToolIterations;
    };
    model_list = cfg.modelList;
    channels = cfg.channels;
    tools = cfg.tools;
    heartbeat = cfg.heartbeat;
    devices = cfg.devices;
    gateway = cfg.gateway;
  };
in
{
  meta.maintainers = with lib.maintainers; [
    manfredmacx
    drupol
  ];

  options.services.picoclaw = {
    enable = lib.mkEnableOption "picoclaw AI assistant gateway";

    package = lib.mkPackageOption pkgs "picoclaw" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "picoclaw";
      description = "User account under which picoclaw runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "picoclaw";
      description = "Group under which picoclaw runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/picoclaw";
      description = "Directory for picoclaw state, config, and workspace.";
    };

    workspaceDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/picoclaw/.picoclaw/workspace";
      description = "Workspace directory for the picoclaw agent.";
    };

    restrictToWorkspace = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the agent should be restricted to the configured workspace.";
    };

    modelName = lib.mkOption {
      type = lib.types.str;
      default = "gpt4";
      example = "gpt4";
      description = "Default model_name used in agents.defaults.model_name should match model_name in model_list.";
    };

    modelFallbacks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "gpt4-mini"
        "claude-sonnet-4.6"
      ];
      description = "Fallback model names used in agents.defaults.model_fallbacks.";
    };

    modelList = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
      default = [ ];
      description = "Model entries for top-level model_list.";
      example = lib.literalExpression ''
        [
          {
            model_name = "gpt4";
            model = "openai/gpt-5.2";
            api_key = "sk-...";
            api_base = "https://api.openai.com/v1";
          }
        ]
      '';
    };

    maxTokens = lib.mkOption {
      type = lib.types.int;
      default = 8192;
      description = "Maximum tokens per request.";
    };

    temperature = lib.mkOption {
      type = lib.types.float;
      default = 0.7;
      description = "Sampling temperature for the model.";
    };

    maxToolIterations = lib.mkOption {
      type = lib.types.int;
      default = 20;
      description = "Maximum tool call iterations per agent run.";
    };

    channels = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Chat channel configurations (telegram, discord, etc).";
      example = lib.literalExpression ''
        {
          telegram = {
            enabled = true;
            token = "YOUR_BOT_TOKEN";
            allow_from = [ "YOUR_USER_ID" ];
          };
        }
      '';
    };

    tools = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Tool configurations (web search, etc).";
      example = lib.literalExpression ''
        {
          web = {
            brave = {
              enabled = true;
              api_key = "";
              max_results = 5;
            };
            perplexity = {
              enabled = true;
              api_key = "";
              max_results = 5;
            };
            duckduckgo = {
              enabled = true;
              max_results = 5;
            };
          };
        }
      '';
    };

    heartbeat = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Top-level heartbeat settings.";
      example = lib.literalExpression ''
        {
          enabled = true;
          interval = 30;
        }
      '';
    };

    devices = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Top-level devices settings.";
      example = lib.literalExpression ''
        {
          enabled = false;
          monitor_usb = true;
        }
      '';
    };

    gateway = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Top-level gateway bind settings.";
      example = lib.literalExpression ''
        {
          host = "127.0.0.1";
          port = 18790;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      description = "picoclaw service user";
    };

    users.groups.${cfg.group} = { };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "picoclaw" ''
        exec sudo -u ${cfg.user} HOME=${cfg.dataDir} ${lib.getExe cfg.package} "$@"
      '')
    ];

    systemd.services.picoclaw = {
      description = "PicoClaw AI Assistant Gateway";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        HOME = cfg.dataDir;
      };

      preStart = ''
        mkdir -p ${cfg.dataDir}/.picoclaw
        mkdir -p ${cfg.workspaceDir}
        cp ${configFile} ${cfg.dataDir}/.picoclaw/config.json
        chmod 640 ${cfg.dataDir}/.picoclaw/config.json
        chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} gateway";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        RestartSec = "5s";
        PermissionsStartOnly = true;

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
      };
    };
  };
}

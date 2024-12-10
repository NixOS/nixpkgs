{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  format = pkgs.formats.yaml { };
  cfg = config.services.private-gpt;
in
{
  options = {
    services.private-gpt = {
      enable = lib.mkEnableOption "private-gpt for local large language models";
      package = lib.mkPackageOption pkgs "private-gpt" { };

      stateDir = lib.mkOption {
        type = types.path;
        default = "/var/lib/private-gpt";
        description = "State directory of private-gpt.";
      };

      settings = lib.mkOption {
        type = format.type;
        default = {
          llm = {
            mode = "ollama";
            tokenizer = "";
          };
          embedding = {
            mode = "ollama";
          };
          ollama = {
            llm_model = "llama3";
            embedding_model = "nomic-embed-text";
            api_base = "http://localhost:11434";
            embedding_api_base = "http://localhost:11434";
            keep_alive = "5m";
            tfs_z = 1;
            top_k = 40;
            top_p = 0.9;
            repeat_last_n = 64;
            repeat_penalty = 1.2;
            request_timeout = 120;
          };
          vectorstore = {
            database = "qdrant";
          };
          qdrant = {
            path = "/var/lib/private-gpt/vectorstore/qdrant";
          };
          data = {
            local_data_folder = "/var/lib/private-gpt";
          };
          openai = { };
          azopenai = { };
        };
        description = ''
          settings-local.yaml for private-gpt
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.private-gpt = {
      description = "Interact with your documents using the power of GPT, 100% privately, no data leaks";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart =
        let
          config = format.generate "settings-local.yaml" (cfg.settings // { server.env_name = "local"; });
        in
        ''
          mkdir -p ${cfg.stateDir}/{settings,huggingface,matplotlib,tiktoken_cache}
          cp ${cfg.package.cl100k_base.tiktoken} ${cfg.stateDir}/tiktoken_cache/9b5ad71b2ce5302211f9c61530b329a4922fc6a4
          cp ${pkgs.python3Packages.private-gpt}/${pkgs.python3.sitePackages}/private_gpt/settings.yaml ${cfg.stateDir}/settings/settings.yaml
          cp "${config}" "${cfg.stateDir}/settings/settings-local.yaml"
          chmod 600 "${cfg.stateDir}/settings/settings-local.yaml"
        '';

      environment = {
        PGPT_PROFILES = "local";
        PGPT_SETTINGS_FOLDER = "${cfg.stateDir}/settings";
        HF_HOME = "${cfg.stateDir}/huggingface";
        TRANSFORMERS_OFFLINE = "1";
        HF_DATASETS_OFFLINE = "1";
        MPLCONFIGDIR = "${cfg.stateDir}/matplotlib";
      };

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "private-gpt";
        RuntimeDirectory = "private-gpt";
        RuntimeDirectoryMode = "0755";
        PrivateTmp = true;
        DynamicUser = true;
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ drupol ];
}

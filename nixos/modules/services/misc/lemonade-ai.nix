{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.services.lemonade-ai;
  boolToLemonadeBool = b: if b then "1" else "0";
in
{
  options = {
    services.lemonade-ai = {
      enable = lib.mkEnableOption "Lemonade AI server";

      package = lib.mkPackageOption pkgs "lemonade-ai" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "lemonade";
        description = "User account under which lemonade-server runs";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The host address the lemonade server should listen on.";
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        description = "The port the lemonade server should listen on.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the lemonade server.";
      };

      logLevel = mkOption {
        type = types.enum [
          "trace"
          "debug"
          "info"
          "warning"
          "error"
          "critical"
        ];
        default = "info";

        description = "Logging level.";
      };

      llamaCppBackend = mkOption {
        type = types.nullOr (
          types.enum [
            "vulkan"
            "rocm"
            "cpu"
            "system"
          ]
        );
        default = "system";
        description = "Default LlamaCpp backend.";
      };

      whisperCppBackend = mkOption {
        type = types.nullOr (
          types.enum [
            "cpu"
            "vulkan"
          ]
        );
        default = null;
        description = "Default WhisperCpp backend (cpu or vulkan on Linux).";
      };

      contextSize = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Default context size for models.";
      };

      llamaCppArgs = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Custom arguments for llama-server.";
      };

      flmArgs = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Custom arguments for FLM server.";
      };

      extraModelsDir = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Secondary directory for GGUF model files.";
      };

      maxLoadedModels = mkOption {
        type = types.int;
        default = 1;
        description = "Maximum number of models to keep loaded per type. -1 for unlimited.";
      };

      disableModelFiltering = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Disable hardware-based model filtering.";
      };

      enableDGPUGTT = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Include GTT for hardware-based model filtering.";
      };

      globalTimeout = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Global timeout for HTTP requests and inference.";
      };

      llamaCppRocmBin = lib.mkPackageOption pkgs "llama-cpp-rocm" {
        nullable = true;
        extraDescription = ''
          Custom path to llama-server binary with ROCm support.
        '';
      };

      llamaCppVulkanBin = lib.mkPackageOption pkgs "llama-cpp-vulkan" {
        nullable = true;
        extraDescription = ''
          Custom path to llama-server binary with Vulkan support.
        '';
      };

      llamaCppCpuBin = lib.mkPackageOption pkgs "llama-cpp" {
        nullable = true;
        extraDescription = ''
          Custom path to llama-server binary with CPU support.
        '';
      };

      whisperCppCpuBin = lib.mkPackageOption pkgs "whisper-cpp" {
        nullable = true;
        extraDescription = ''
          Custom path to whisper-server binary with CPU support.
        '';
      };

      whisperCppNpuBin = lib.mkPackageOption pkgs "whisper-cpp" {
        nullable = true;
        extraDescription = ''
          Custom path to whisper-server binary with NPU support.
        '';
      };

      ryzenAIServerBin = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Custom path to ryzenai-server binary.";
      };

      apiKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/lemonade-api-key";
        description = ''
          A file containing the API key.

          If you expose your server over a network you can use this config
          option to set an API key (use a random long string) that will be
          required to execute any request.

          The API key will be expected as HTTP Bearer authentication, which is
          compatible with the OpenAI API.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users = lib.mkIf (cfg.user == "lemonade") {
      lemonade = {
        isSystemUser = true;
        group = "lemonade";
        description = "Lemonade server daemon user";
      };
    };

    users.groups = lib.mkIf (cfg.user == "lemonade") { lemonade = { }; };

    systemd.services.lemonade-ai = {
      description = "Lemonade Server";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
      ];

      path = with pkgs; [
        gnutar
        procps
      ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/lemonade-server serve";
        User = "${cfg.user}";

        KillSignal = "SIGINT";
        LimitMEMLOCK = "infinity";

        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "full";
        ProtectHome = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        LoadCredential = lib.optionalString (cfg.apiKeyFile != null) "LEMONADE_API_KEY:${cfg.apiKeyFile}";
        StateDirectory = "lemonade-ai";
      };

      environment = {
        HOME = "/var/lib/lemonade-ai";
        LEMONADE_HOST = cfg.host;
        LEMONADE_PORT = toString cfg.port;
        LEMONADE_LOG_LEVEL = cfg.logLevel;
      }
      // lib.optionalAttrs (cfg.llamaCppBackend != null) { LEMONADE_LLAMACPP = cfg.llamaCppBackend; }
      // lib.optionalAttrs (cfg.whisperCppBackend != null) {
        LEMONADE_WHISPERCPP = cfg.whisperCppBackend;
      }
      // lib.optionalAttrs (cfg.contextSize != null) { LEMONADE_CTX_SIZE = toString cfg.contextSize; }
      // lib.optionalAttrs (cfg.llamaCppArgs != null) { LEMONADE_LLAMACPP_ARGS = cfg.llamaCppArgs; }
      // lib.optionalAttrs (cfg.flmArgs != null) { LEMONADE_FLM_ARGS = cfg.flmArgs; }
      // lib.optionalAttrs (cfg.extraModelsDir != null) {
        LEMONADE_EXTRA_MODELS_DIR = cfg.extraModelsDir;
      }
      // lib.optionalAttrs (cfg.maxLoadedModels != null) {
        LEMONADE_MAX_LOADED_MODELS = toString cfg.maxLoadedModels;
      }
      // lib.optionalAttrs (cfg.disableModelFiltering != null) {
        LEMONADE_DISABLE_MODEL_FILTERING = boolToLemonadeBool cfg.disableModelFiltering;
      }
      // lib.optionalAttrs (cfg.enableDGPUGTT != null) {
        LEMONADE_ENABLE_DGPU_GTT = boolToLemonadeBool cfg.enableDGPUGTT;
      }
      // lib.optionalAttrs (cfg.globalTimeout != null) {
        LEMONADE_GLOBAL_TIMEOUT = toString cfg.globalTimeout;
      }
      // lib.optionalAttrs (cfg.globalTimeout != null) {
        LEMONADE_GLOBAL_TIMEOUT = toString cfg.globalTimeout;
      }
      // lib.optionalAttrs (cfg.llamaCppRocmBin != null) {
        LEMONADE_LLAMACPP_ROCM_BIN = "${cfg.llamaCppRocmBin}/bin/llama-server";
      }
      // lib.optionalAttrs (cfg.llamaCppVulkanBin != null) {
        LEMONADE_LLAMACPP_VULKAN_BIN = "${cfg.llamaCppVulkanBin}/bin/llama-server";
      }
      // lib.optionalAttrs (cfg.llamaCppCpuBin != null) {
        LEMONADE_LLAMACPP_CPU_BIN = "${cfg.llamaCppCpuBin}/bin/llama-server";
      }
      // lib.optionalAttrs (cfg.whisperCppCpuBin != null) {
        LEMONADE_WHISPERCPP_CPU_BIN = "${cfg.whisperCppCpuBin}/bin/whisper-server";
      }
      // lib.optionalAttrs (cfg.whisperCppNpuBin != null) {
        LEMONADE_WHISPERCPP_NPU_BIN = "${cfg.whisperCppNpuBin}/bin/whisper-server";
      }
      // lib.optionalAttrs (cfg.ryzenAIServerBin != null) {
        LEMONADE_RYZENAI_SERVER_BIN = cfg.ryzenAIServerBin;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ videl ];
}

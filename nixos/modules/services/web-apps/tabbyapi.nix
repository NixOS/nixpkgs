{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.tabbyapi;
  yamlFormat = pkgs.formats.yaml { };
  configFile = yamlFormat.generate "config.yml" cfg.settings;
in
{
  options.services.tabbyapi = {
    enable = lib.mkEnableOption "tabbyapi";

    package = lib.mkPackageOption pkgs "tabbyapi" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the TabbyAPI port.";
    };

    settings = lib.mkOption {
      description = ''
        Configuration for TabbyAPI.
        See https://github.com/theroyallab/tabbyAPI/wiki/02.-Server-options and https://github.com/theroyallab/tabbyAPI/blob/main/config_sample.yml
      '';
      example = lib.literalExpression ''
        {
          model = {
            model_name = "Qwen3_5-9B";
            max_seq_len = 32768;
            cache_mode = "8,8";
            tensor_parallel = true;
            gpu_split = [ 16 24 ];
          };
          draft_model.draft_mode = "ngram";
          memory.sysmem_kv_cache = 4096;
        }
      '';
      type = lib.types.submodule {
        freeformType = yamlFormat.type;

        options = {
          network = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = ''
                The IP to host on.
                Use 0.0.0.0 to expose on all network adapters.
              '';
              example = "0.0.0.0";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 5000;
              description = ''
                The port to host on.
              '';
              example = 8080;
            };

            disable_auth = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Disable HTTP token authentication with requests.
                WARNING: This will make your instance vulnerable!
                Only turn this on if nothing but trusted local clients can reach the API.
                Note that web pages open in a browser on this machine also count as local
                callers; restrict `network.allowed_origins` if you disable auth.
              '';
            };
          };

          model = {
            model_dir = lib.mkOption {
              type = lib.types.str;
              default = "models";
              description = ''
                Directory to look for models.
                Relative to the state directory.
              '';
              example = lib.literalExpression ''
                (pkgs.linkFarm "models" {
                  qwen-8b = pkgs.fetchgit {
                    url = "https://huggingface.co/turboderp/Qwen3-VL-8B-Instruct-exl3";
                    rev = "652ab6be95b3e2880e78d87269013d98ca9c392d"; # 4bpw
                    fetchLFS = true;
                    hash = "sha256-n+9Mt7EZ3XHM0w8oGUZr4EBz91EFyp1VBpvl9Php/QM=";
                  };
              '';
            };

            model_name = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                An initial model to load.
                Make sure the model is located in the model directory!
                REQUIRED: This must be filled out to load a model on startup.
              '';
              example = "Qwen3_5-9B";
            };

            max_seq_len = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = ''
                Max sequence length (default: 4096).
                Set to -1 to fetch from the model's config.json
              '';
              example = 32768;
            };

            cache_mode = lib.mkOption {
              type = lib.types.str;
              default = "FP16";
              description = ''
                Enable different cache modes for VRAM savings.
                Specify the pair k_bits,v_bits where k_bits and v_bits are integers from 2-8.
                The legacy values 'FP16', 'Q8', 'Q6', 'Q4' are also accepted.
              '';
              example = "8,8";
            };
          };

          draft_model = {
            draft_model_dir = lib.mkOption {
              type = lib.types.str;
              default = "models";
              description = ''
                Directory to look for draft models
                Relative to the state directory.
              '';
              example = "drafts";
            };

            draft_model_name = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                An initial draft model to load.
                Ensure the model is in the model directory.
              '';
              example = "Qwen3-0.6B-exl3";
            };
          };

          lora = {
            lora_dir = lib.mkOption {
              type = lib.types.str;
              default = "loras";
              description = ''
                Directory to look for LoRAs.
                Relative to the state directory.
              '';
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package.passthru.cudaSupport || cfg.package.passthru.rocmSupport;
        message = ''
          TabbyAPI requires CUDA or ROCm support to function.
          Consider setting:
            services.tabbyapi.package = pkgs.pkgsCuda.tabbyapi;
            services.tabbyapi.package = pkgs.pkgsRocm.tabbyapi;
        '';
      }
      {
        assertion = !(cfg.settings.model ? force_enable_thinking);
        message = ''
          services.tabbyapi.settings.model.force_enable_thinking is deprecated upstream.
          Use template_vars_force instead:
            services.tabbyapi.settings.model.template_vars_force.enable_thinking = true;
        '';
      }
    ];
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.settings.network.port
    ];

    systemd.services.tabbyapi = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = "TabbyAPI - OAI compatible server for Exllama";

      # Triton & huggingface downloader need writable cache folders
      environment = {
        HOME = "/var/lib/tabbyapi";
        XDG_CACHE_HOME = "/var/lib/tabbyapi/.cache";
        TRITON_CACHE_DIR = "/tmp/triton";
      };

      preStart = ''
        ln -sfn ${cfg.package}/share/tabbyapi/sampler_overrides sampler_overrides
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config=${configFile}";
        Restart = "on-failure";
        StateDirectory = "tabbyapi";
        WorkingDirectory = "/var/lib/tabbyapi";
        User = "tabbyapi";
        Group = "tabbyapi";
        DynamicUser = true;

        # Hardening
        ProtectSystem = "strict";
        ProtectHome = "yes";
        LockPersonality = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ BatteredBunny ];
}

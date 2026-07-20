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
        Configuration for TabbyAPI. https://github.com/theroyallab/tabbyAPI/wiki/02.-Server-options
      '';
      type = lib.types.submodule {
        freeformType = yamlFormat.type;

        options = {
          network = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = "The IP to host on. Use 0.0.0.0 to expose on all network adapters.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 5000;
              description = "The port to host on.";
            };

            disable_auth = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Disable HTTP token authentication with requests.
                WARNING: This will make your instance vulnerable! Only turn this on if you are ONLY connecting from localhost.
              '';
            };

            disable_fetch_requests = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Disable fetching external content in response to requests, such as images from URLs.";
            };

            api_servers = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "OAI" ];
              description = "Select API servers to enable. Possible values: OAI, Kobold.";
            };
          };

          logging = {
            log_prompt = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable prompt logging.";
            };

            log_requests = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable request logging. NOTE: Only use this for debugging!";
            };

            log_chat_completion_requests = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Write every /v1/chat/completions request to logs/debug/ as JSON.
                PRIVACY WARNING: Enabling this creates a comprehensive request log, including the
                full message history and generation parameters. API keys are redacted, but prompts
                and user-provided content are preserved for bug-report reproduction.
              '';
            };
          };

          model = {
            model_dir = lib.mkOption {
              type = lib.types.str;
              default = "models";
              description = "Directory to look for models. Relative to the state directory.";
              example = lib.literalExpression ''
                (pkgs.linkFarm "models" {
                  qwen-8b = pkgs.fetchgit {
                    url = "https://huggingface.co/turboderp/Qwen3-VL-8B-Instruct-exl3";
                    rev = "652ab6be95b3e2880e78d87269013d98ca9c392d"; # 4bpw
                    fetchLFS = true;
                    hash = "sha256-n+9Mt7EZ3XHM0w8oGUZr4EBz91EFyp1VBpvl9Php/QM=";
                  };

                  # Example for patching Qwen 3.5's template to work with OpenWebUI's thinking feature
                  Qwen3_5-9B = pkgs.applyPatches {
                    src = pkgs.fetchgit {
                      url = "https://huggingface.co/turboderp/Qwen3.5-9B-exl3";
                      rev = "6f8763307a3130ae989269fbc79a8c8e9db5ee42"; # 5.0bpw
                      fetchLFS = true;
                      hash = "sha256-Y7Uw/MChXU0Iu9hb3dv+cTtNBwhPbd/I/gYDUjM1j8g=";
                    };
                    patches = [ ./qwen-thinking.patch ];
                  };
                  # diff --git a/chat_template.jinja b/chat_template.jinja
                  # index a585dec..68f1b6f 100644
                  # --- a/chat_template.jinja
                  # +++ b/chat_template.jinja
                  # @@ -148,7 +148,5 @@
                  #     {{- '<|im_start|>assistant\n' }}
                  #     {%- if enable_thinking is defined and enable_thinking is false %}
                  #         {{- '<think>\n\n</think>\n\n' }}
                  # -    {%- else %}
                  # -        {{- '<think>\n' }}
                  #     {%- endif %}
                  # {%- endif %}
                  # \ No newline at end of file
                }).outPath;
              '';
            };

            inline_model_loading = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Allow direct loading of models from a completion or chat completion request.
                This method of loading is strict by default; enable dummy models to add
                exceptions for invalid model names.
              '';
            };

            model_name = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                An initial model to load. Make sure the model is located in the model directory!
                REQUIRED: This must be filled out to load a model on startup.
              '';
              example = "Qwen3_5-9B";
            };

            max_seq_len = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = ''
                Max sequence length (default: min(max_position_embeddings, cache_size)).
                Set to -1 to fetch from the model's config.json.
              '';
            };

            cache_mode = lib.mkOption {
              type = lib.types.str;
              default = "FP16";
              description = ''
                Enable different cache modes for VRAM savings.
                Specify the pair k_bits,v_bits where k_bits and v_bits are integers from 2-8 (e.g. '8,8').
                The legacy values 'FP16', 'Q8', 'Q6', 'Q4' are also accepted.
              '';
            };

            tensor_parallel = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Load model with tensor parallelism.
                Falls back to autosplit if GPU split isn't provided. This ignores the gpu_split_auto value.
              '';
            };

            gpu_split_auto = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Automatically allocate resources to GPUs. Not parsed for single GPU users.";
            };

            dummy_model_names = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "gpt-3.5-turbo" ];
              description = ''
                A list of fake model names that are sent via the /v1/models endpoint.
                Also used as bypasses for strict mode if inline_model_loading is true.
              '';
            };

            vision = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enables vision support if the model supports it.";
            };

            reasoning = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Enable reasoning parser.
                Do NOT enable this if the model is not a reasoning model (e.g. deepseek-r1 series).
              '';
            };

            reasoning_start_token = lib.mkOption {
              type = lib.types.str;
              default = "<think>";
              description = "The start token for reasoning content.";
            };

            reasoning_end_token = lib.mkOption {
              type = lib.types.str;
              default = "</think>";
              description = "The end token for reasoning content.";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package.passthru.cudaSupport;
        message = ''
          TabbyAPI requires CUDA support to function. The configured package does not have CUDA enabled.
          Consider setting:
            services.tabbyapi.package = pkgs.pkgsCuda.tabbyapi;
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

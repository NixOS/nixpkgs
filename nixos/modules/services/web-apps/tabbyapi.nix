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
              example = "0.0.0.0";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 5000;
              description = "The port to host on.";
              example = 8080;
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

            send_tracebacks = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Send tracebacks over the API.
                NOTE: Only enable this for debug purposes.
              '';
            };

            api_servers = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "OAI" ];
              description = "Select API servers to enable. Possible values: OAI, Kobold.";
              example = [
                "OAI"
                "Kobold"
              ];
            };

            sse_ping_interval = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 15;
              description = ''
                Seconds between SSE keep-alive pings on streaming responses.
                Pings are SSE comments, ignored by compliant clients, and prevent
                connections from dropping during long prefills. Set to 0 to disable.
              '';
              example = 0;
            };
          };

          logging = {
            log_prompt = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable prompt logging.";
            };

            log_generation_params = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable generation parameter logging.";
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

            use_dummy_models = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Sends dummy model names when the models endpoint is queried.
                Enable this if the client is looking for specific OAI models.
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

            use_as_default = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                Names of args to use as a fallback for API load requests.
                For example, if you always want cache_mode to be Q4 instead of only on the
                initial model load, add "cache_mode" to this list.
              '';
              example = [
                "max_seq_len"
                "cache_mode"
              ];
            };

            max_seq_len = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = ''
                Max sequence length (default: min(max_position_embeddings, cache_size)).
                Set to -1 to fetch from the model's config.json.
              '';
              example = 32768;
            };

            cache_size = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.addCheck lib.types.ints.positive (n: lib.mod n 256 == 0)
                // {
                  description = "positive integer, multiple of 256";
                }
              );
              default = null;
              description = ''
                Size of the key/value cache to allocate, in tokens (default: 4096).
                Must be a multiple of 256.
              '';
              example = 32768;
            };

            cache_mode = lib.mkOption {
              type = lib.types.str;
              default = "FP16";
              description = ''
                Enable different cache modes for VRAM savings.
                Specify the pair k_bits,v_bits where k_bits and v_bits are integers from 2-8 (e.g. '8,8').
                The legacy values 'FP16', 'Q8', 'Q6', 'Q4' are also accepted.
              '';
              example = "8,8";
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

            autosplit_reserve = lib.mkOption {
              type = lib.types.listOf lib.types.number;
              default = [ 96 ];
              description = ''
                Reserve VRAM used for autosplit loading, as a list of MB per GPU
                (default: 96 MB on GPU 0).
              '';
              example = [
                96
                96
              ];
            };

            gpu_split = lib.mkOption {
              type = lib.types.listOf lib.types.number;
              default = [ ];
              description = ''
                List of VRAM sizes to split between GPUs, in GB.
                Used with tensor parallelism.
              '';
              example = [
                16
                24
              ];
            };

            cpu_moe_offload_layers = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 0;
              description = ''
                Number of mixture-of-expert layers to offload to CPU inference.
                Only affects MoE models. Set a large value such as 999 to offload all layers.
              '';
              example = 999;
            };

            rope_scale = lib.mkOption {
              type = lib.types.nullOr lib.types.number;
              default = 1.0;
              description = ''
                Rope scale, same as compress_pos_emb.
                Use if the model was trained on long context with rope.
                Set to null to pull the value from the model.

                NOTE: If a model has YaRN rope scaling, it will automatically be enabled by
                ExLlama and the rope_scale and rope_alpha settings won't apply.
              '';
              example = 4.0;
            };

            rope_alpha = lib.mkOption {
              type = lib.types.nullOr (lib.types.either lib.types.number (lib.types.enum [ "auto" ]));
              default = null;
              description = ''
                Rope alpha, same as alpha_value. Set to "auto" to auto-calculate.
                Leaving this null will either pull from the model or auto-calculate.
              '';
              example = "auto";
            };

            chunk_size = lib.mkOption {
              type = lib.types.ints.positive;
              default = 2048;
              description = ''
                Chunk size for prompt ingestion.
                A lower value reduces VRAM usage but decreases ingestion speed.
                NOTE: Effects vary depending on the model. An ideal value is between 512 and 4096.
              '';
              example = 512;
            };

            output_chunking = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Use output chunking. Instead of allocating cache space for the entire completion
                at once, allocate in chunks as needed. Used by EXL3 models only.
              '';
            };

            max_batch_size = lib.mkOption {
              type = lib.types.nullOr lib.types.ints.positive;
              default = null;
              description = ''
                Set the maximum number of generation jobs that can run concurrently.
                The default maximum batch size for transformer architectures is 32. Recurrent
                models with linear or sliding attention use more VRAM to support larger batches,
                so the default value is reduced to 4. If you do not require concurrency at all,
                you can reduce it further to minimize VRAM overhead.
              '';
              example = 1;
            };

            prompt_template = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Set the prompt template for this model.
                If null, attempts to look for the model's chat template.
                If a model contains multiple templates in its tokenizer_config.json,
                set this to the name of the template you want to use.
                NOTE: Only works with chat completion message lists!
              '';
            };

            dummy_model_names = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "gpt-3.5-turbo" ];
              description = ''
                A list of fake model names that are sent via the /v1/models endpoint.
                Also used as bypasses for strict mode if inline_model_loading is true.
              '';
              example = [
                "gpt-3.5-turbo"
                "gpt-4"
              ];
            };

            vision = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enables vision support if the model supports it.";
            };

            template_vars_default = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = ''
                Default chat template variables. Merged into the template variables of every
                chat completion request; values sent by the client (template_vars /
                chat_template_kwargs, or the top-level reasoning_effort field) take precedence.
                Use for model-specific reasoning knobs.
              '';
              example = {
                enable_thinking = true;
              };
            };

            template_vars_force = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = ''
                Forced chat template variables. Like template_vars_default, but these override
                any values sent by the client.
                Replaces the deprecated force_enable_thinking option, which is still accepted
                as an alias for { enable_thinking = true; }.
              '';
              example = {
                reasoning_effort = "high";
              };
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

            start_in_reasoning = lib.mkOption {
              type = lib.types.enum [
                "auto"
                "always"
                "never"
              ];
              default = "auto";
              description = ''
                Whether generation starts inside a reasoning block.
                "auto" guesses by scanning the end of the templated prompt for an unclosed
                reasoning start token.
              '';
              example = "always";
            };

            tool_calls_in_reasoning = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Parse tool calls that occur inside reasoning content.
                If false, tool call tags inside a reasoning block are treated as plain
                reasoning text.
              '';
            };

            tool_format = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Tool format, e.g. "qwen3_coder". See upstream docs for supported formats.
                If null, tool calls from the model will not be parsed by the server.
              '';
              example = "qwen3_coder";
            };

            harmony = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = ''
                Parse responses in the Harmony message format (gpt-oss models).
                Auto-detected from the model's special tokens when null; set to true or false
                to override. Setting tool_format to "harmony" is equivalent to setting this to
                true. When active, supersedes the reasoning and tool format settings.
              '';
            };
          };

          draft_model = {
            draft_mode = lib.mkOption {
              type = lib.types.enum [
                "model"
                "disabled"
                "mtp"
                "ngram"
              ];
              default = "model";
              description = ''
                Drafting mode for exllamav3.
                In "model" mode, drafting is disabled if no draft_model_name is provided.
              '';
              example = "ngram";
            };

            draft_model_dir = lib.mkOption {
              type = lib.types.str;
              default = "models";
              description = "Directory to look for draft models. Relative to the state directory.";
              example = "drafts";
            };

            draft_model_name = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                An initial draft model to load.
                Ensure the model is in the draft model directory.
              '';
              example = "Qwen3-0.6B-exl3";
            };

            draft_rope_scale = lib.mkOption {
              type = lib.types.nullOr lib.types.number;
              default = 1.0;
              description = ''
                Rope scale for draft models, same as compress_pos_emb.
                Use if the draft model was trained on long context with rope.
              '';
              example = 4.0;
            };

            draft_rope_alpha = lib.mkOption {
              type = lib.types.nullOr lib.types.number;
              default = null;
              description = ''
                Rope alpha for draft models, same as alpha_value.
                Leaving this null will either pull from the model or auto-calculate.
              '';
              example = 2.0;
            };

            draft_cache_mode = lib.mkOption {
              type = lib.types.enum [
                "FP16"
                "Q8"
                "Q6"
                "Q4"
              ];
              default = "FP16";
              description = ''
                Cache mode for draft models to save VRAM.
                Unlike the model's cache_mode, this does not accept a k_bits,v_bits pair.
              '';
              example = "Q8";
            };

            draft_gpu_split = lib.mkOption {
              type = lib.types.listOf lib.types.number;
              default = [ ];
              description = ''
                List of VRAM sizes to split between GPUs, in GB.
                If this is empty, the draft model is autosplit.
              '';
              example = [
                2
                2
              ];
            };

            draft_num_tokens = lib.mkOption {
              type = lib.types.nullOr lib.types.ints.positive;
              default = null;
              description = ''
                Number of tokens to draft per iteration (default: draft model default).
                Recurrent (linear or sliding attention) models use more VRAM for longer drafts.
                This overhead multiplies with the max batch size, so for models with long drafts
                (e.g. DFlash with 15 tokens by default) shorter drafts may be preferable.
              '';
              example = 4;
            };

            dynamic_draft = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Adjust number of draft tokens dynamically based on observed acceptance rates.
                Ceiling is given by draft_num_tokens.
              '';
            };

            ngram_match_min = lib.mkOption {
              type = lib.types.ints.positive;
              default = 2;
              description = ''
                Minimum match length for exllamav3 n-gram drafting.
                Only used when draft_mode is "ngram".
              '';
              example = 3;
            };
          };

          sampling = {
            override_preset = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Select a sampler override preset, found in the sampler-overrides folder.
                This overrides default fallbacks for sampler values that are passed to the API.
                NOTE: "safe_defaults" is noob friendly and provides fallbacks for frontends that
                don't send sampling parameters. Leave this null for any advanced usage.
              '';
              example = "safe_defaults";
            };
          };

          lora = {
            lora_dir = lib.mkOption {
              type = lib.types.str;
              default = "loras";
              description = "Directory to look for LoRAs. Relative to the state directory.";
            };

            loras = lib.mkOption {
              type = lib.types.listOf (
                lib.types.submodule {
                  options = {
                    name = lib.mkOption {
                      type = lib.types.str;
                      description = "Name of the LoRA directory inside lora_dir.";
                    };

                    scaling = lib.mkOption {
                      type = lib.types.number;
                      default = 1.0;
                      description = "Scaling factor for this LoRA.";
                    };
                  };
                }
              );
              default = [ ];
              description = "List of LoRAs to load and associated scaling factors.";
              example = [
                {
                  name = "lora1";
                  scaling = 1.0;
                }
              ];
            };
          };

          memory = {
            sysmem_recurrent_cache = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 4096;
              description = "Max size of recurrent cache in system memory, in MB.";
              example = 8192;
            };

            sysmem_kv_cache = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 0;
              description = "Size of system memory second-tier key/value cache, in MB.";
              example = 4096;
            };

            cuda_malloc_async = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Use the cudaMallocAsync backend in Torch.
                Enabling this is generally preferable, but it may cause issues with certain
                workloads. Try disabling it if you experience intermittent OoM errors. If false,
                Torch will use the allocator defined by the system environment.
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
        assertion = cfg.package.passthru.cudaSupport;
        message = ''
          TabbyAPI requires CUDA support to function. The configured package does not have CUDA enabled.
          Consider setting:
            services.tabbyapi.package = pkgs.pkgsCuda.tabbyapi;
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

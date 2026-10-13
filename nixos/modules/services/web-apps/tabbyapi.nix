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

  multipleOf256 = lib.types.addCheck lib.types.ints.positive (n: lib.mod n 256 == 0) // {
    description = "positive integer, multiple of 256";
  };
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
                callers; restrict allowed_origins below if you disable auth.
              '';
            };

            allowed_origins = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "*" ];
              description = ''
                Origins allowed to call the API from a browser.
                This is a CORS allowlist, not an auth mechanism: it only governs which
                web pages a browser will let read this API's responses.
                The default "*" means any site open in your browser can send requests to
                this instance, which matters most when disable_auth is on. Restrict this to
                your own frontends to close that off, or
                use an empty list [] to block all browser (cross-origin) callers.
              '';
              example = [ "http://localhost:8000" ];
            };

            disable_fetch_requests = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Disable fetching external content in response to requests, such as images from URLs.
              '';
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
              description = ''
                Select API servers to enable.
                Possible values: OAI, Kobold.
              '';
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

            access_log = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Log every HTTP request with client address, method, path and status.
                Generation requests are already logged in detail; this adds the rest, such as model list and health polls.
              '';
            };
          };

          logging = {
            log_prompt = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Enable prompt logging.
              '';
            };

            log_generation_params = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Enable generation parameter logging.
              '';
            };

            log_requests = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Enable request logging.
                NOTE: Only use this for debugging!
              '';
            };

            log_timestamps = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Prefix console log lines with the time of day.
                The log files under logs/ always carry full timestamps.
              '';
            };

            log_chat_completion_requests = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Write every /v1/chat/completions request to logs/debug/ as JSON.
                Also saves the fully templated prompt (the exact text sent to the tokenizer) as a .txt file with the same basename.
                PRIVACY WARNING: Enabling this creates a comprehensive request log, including the full message history and generation parameters. API keys are redacted, but prompts and user-provided content are preserved for bug-report reproduction.
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
                This method of loading is strict: a request naming a model that
                doesn't exist or fails to load is rejected instead of running on the
                loaded model. Enable dummy models to add exceptions for model names
                that clients send without meaning a specific model.
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
                An initial model to load.
                Make sure the model is located in the model directory!
                REQUIRED: This must be filled out to load a model on startup.
              '';
              example = "Qwen3_5-9B";
            };

            use_as_default = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                Names of args to use as a fallback for API load requests.
                For example, if you always want cache_mode to be Q4 instead of on the initial model load, add "cache_mode" to this array.
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
                Max sequence length (default: 4096).
                Set to -1 to fetch from the model's config.json
              '';
              example = 32768;
            };

            cache_size = lib.mkOption {
              type = lib.types.nullOr multipleOf256;
              default = null;
              description = ''
                Size of the prompt cache to allocate (default: max_seq_len).
                Must be a multiple of 256 and can't be less than max_seq_len.
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

            tensor_parallel = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Load model with tensor parallelism.
                Falls back to autosplit if GPU split isn't provided.
                This ignores the gpu_split_auto value.
              '';
            };

            gpu_split_auto = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Automatically allocate resources to GPUs.
                Not parsed for single GPU users.
              '';
            };

            autosplit_reserve = lib.mkOption {
              type = lib.types.listOf lib.types.number;
              default = [ 96 ];
              description = ''
                Reserve VRAM used when loading a model (default: 96 MB on GPU 0).
                Represented as an array of MB per GPU.
                A negative value excludes that GPU from the model split, so
                excluding every GPU will fail to load.
                Ignored for a model whose placement is already set by gpu_split
                or draft_gpu_split.
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
                Array of VRAM sizes to split between GPUs, in GB.
                Used both with and without tensor parallelism.
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
                Number of mixture-of-expert layers to offload to CPU inference
                Only affects MoE models. Set a large value such as 999 to offload all layers
                Mutually exclusive with cpu_moe_split_experts.
              '';
              example = 999;
            };

            cpu_moe_split_experts = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 0;
              description = ''
                Number of routed experts per MoE layer to offload to CPU inference. Unlike cpu_moe_offload_layers, this splits every MoE
                layer instead of offloading whole layers: the coldest experts are
                kept in system RAM and computed on the CPU, overlapping each
                layer's own GPU compute, with dynamic placement keeping hot
                experts in VRAM. Mutually exclusive with cpu_moe_offload_layers;
                not supported with tensor parallelism.
              '';
              example = 4;
            };

            cpu_moe_threads = lib.mkOption {
              type = lib.types.nullOr lib.types.ints.unsigned;
              default = null;
              description = ''
                Worker thread count for CPU MoE inference.
                Applies to both cpu_moe_offload_layers and cpu_moe_split_experts.
                When null, defers to the EXL3_MOE_CPU_THREADS environment
                variable, then half the CPU core count.
              '';
              example = 8;
            };

            ngram_ram = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Load a model's n-gram embedding table fully into system RAM. Only affects PLE models with n-gram embeddings
                (e.g. Qwen3.8-Flash-Next). By default the table is streamed from
                disk during inference; loading it into RAM avoids per-token disk
                reads at the cost of tens of GB of system memory.
              '';
            };

            rope_scale = lib.mkOption {
              type = lib.types.nullOr lib.types.number;
              default = 1.0;
              description = ''
                Rope scale.
                Same as compress_pos_emb.
                Use if the model was trained on long context with rope.
                Set to null to pull the value from the model.
              '';
              example = 4.0;
            };

            rope_alpha = lib.mkOption {
              type = lib.types.nullOr (lib.types.either lib.types.number (lib.types.enum [ "auto" ]));
              default = null;
              description = ''
                Rope alpha.
                Same as alpha_value. Set to "auto" to auto-calculate.
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
                NOTE: Effects vary depending on the model.
                An ideal value is between 512 and 4096.
              '';
              example = 512;
            };

            output_chunking = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Use output chunking
                Instead of allocating cache space for the entire completion at once, allocate in chunks as needed.
                Used by EXL3 models only.
              '';
            };

            max_batch_size = lib.mkOption {
              type = lib.types.nullOr lib.types.ints.positive;
              default = null;
              description = ''
                Set the maximum number of generation jobs that can run concurrently
                The default maximum batch size for transformer architectures is 32. Recurrent
                models with linear or sliding attention use more VRAM to support larger batches,
                so the default value is reduced to 4. If you do not require concurrency at all, you
                can reduce it further to minimize VRAM overhead.
              '';
              example = 1;
            };

            recurrent_checkpoint_interval = lib.mkOption {
              type = lib.types.nullOr multipleOf256;
              default = null;
              description = ''
                Tokens between recurrent state checkpoints near the end of the prompt and
                during generation (default: null, the engine's per-architecture default,
                2048 for most models). Only used by models with recurrent (linear or sliding
                attention) layers. Must be a multiple of 256.
              '';
              example = 1024;
            };

            recurrent_checkpoint_interval_pp = lib.mkOption {
              type = lib.types.nullOr multipleOf256;
              default = null;
              description = ''
                Tokens between recurrent state checkpoints during prompt ingestion, further
                than 2 * chunk_size from the end of the prompt (default: null, the engine
                default of 32768). Only used by models with recurrent layers. Must be a
                multiple of 256 and is rounded up to a multiple of chunk_size.
                Recurrent states cannot be rolled back, so a request that edits an earlier
                part of a cached prompt replays from the last checkpoint before the edit.
                With the default, a long prompt is only checkpointed near its end and an
                early edit costs a full re-prefill; with a denser grid the replay cost becomes
                proportional to the distance from the edit to the end of the prompt.
                Each checkpoint costs one recurrent state of system RAM (148 MiB for a 27B
                hybrid with 48 recurrent layers), bounded by memory.sysmem_recurrent_cache,
                and cold prefill is 2-3% slower at 2048 or 1024.
              '';
              example = 2048;
            };

            prompt_template = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Set the prompt template for this model.
                If null, attempts to look for the model's chat template.
                If a model contains multiple templates in its tokenizer_config.json,
                set prompt_template to the name of the template you want to use.
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
              description = ''
                Enables vision support if the model supports it.
              '';
            };

            warmup = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Warm up the model after loading.
                Runs a short schedule of forward passes so kernel compilation, autotuning
                and CUDA graph capture happen at load time instead of on the first
                requests. Adds some seconds to loading; sized from the cache, batch and
                chunk settings in effect.
              '';
            };

            vision_offload = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Keep the vision model's weights in system RAM instead of VRAM. Weights are stored in pinned host memory and
                streamed to the GPU during inference, trading vision speed for
                VRAM. Only applies when vision is enabled.
              '';
            };

            template_vars_default = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = ''
                Default chat template variables.
                Merged into the template variables of every chat completion request;
                values sent by the client take precedence. Use for model-specific
                reasoning knobs.
              '';
              example = {
                enable_thinking = true;
              };
            };

            template_vars_force = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = ''
                Forced chat template variables.
                Like template_vars_default, but these override any values sent by the client.
              '';
              example = {
                reasoning_effort = "high";
              };
            };

            reasoning = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Enable the reasoning parser.
                Splits the response into reasoning_content and content fields. With the
                tokens below left at auto, reasoning is only parsed when the model's
                template or tokenizer shows which tags it uses.
              '';
            };

            reasoning_start_token = lib.mkOption {
              type = lib.types.str;
              default = "auto";
              description = ''
                Start token for the reasoning parser.
                auto takes the tags from the detected tool format or the chat template;
                set both tokens explicitly to override.
              '';
              example = "<think>";
            };

            reasoning_end_token = lib.mkOption {
              type = lib.types.str;
              default = "auto";
              description = ''
                End token for the reasoning parser.
              '';
              example = "</think>";
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
                Options: auto, always, never
                auto guesses by scanning the end of the templated prompt for an
                unclosed reasoning start token.
              '';
              example = "always";
            };

            tool_calls_in_reasoning = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Parse tool calls that occur inside reasoning content.
                If false, tool call tags inside a reasoning block are treated as
                plain reasoning text.
              '';
            };

            reasoning_budget_tokens = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = ''
                Default reasoning token budget.
                When a request's reasoning content exceeds the budget, the server
                forces the end of the reasoning phase by injecting
                reasoning_budget_message followed by the model's end-of-reasoning
                tokens. 0 ends reasoning as soon as it starts; null or a negative
                value disables the budget. Overridable per request via
                reasoning_budget_tokens (aliases: reasoning_budget,
                thinking_budget, thinking_token_budget) or reasoning.max_tokens.
                Requires a reasoning format: reasoning tags, Harmony or Muse
                Glimmer.
              '';
              example = 1024;
            };

            reasoning_budget_message = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Text injected before the end-of-reasoning tokens when the
                reasoning budget is exhausted (default: no text, only the end-of-reasoning
                tokens are forced). Overridable per request via reasoning_budget_message.
              '';
              example = "Time to answer.";
            };

            tool_format = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = "auto";
              description = ''
                Tool call format. auto picks a parser from the model's
                chat template, tokenizer and architecture, and warns if none matches.
                Set a format name to override; see the Tool Calling
                docs for the supported formats. Set to null to disable tool call parsing.
              '';
              example = "qwen3_coder";
            };

            harmony = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = ''
                Parse responses in the Harmony message format (gpt-oss models).
                Auto-detected from the model's special tokens by default; set to
                true or false to override. Setting 'tool_format: harmony' is
                equivalent to setting this to true. When active, supersedes the
                reasoning and tool format settings.
              '';
            };

            muse_glimmer = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = ''
                Parse responses in the Muse Glimmer message format.
                Auto-detected from the model's special tokens by default; set to
                true or false to override. Setting 'tool_format: muse_glimmer' is
                equivalent to setting this to true. When active, supersedes the
                reasoning and tool format settings.
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
                Drafting mode.
                Options: model, disabled, mtp, ngram.
                In `model` mode, drafting is disabled if no draft_model_name is provided.
              '';
              example = "ngram";
            };

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

            draft_rope_scale = lib.mkOption {
              type = lib.types.nullOr lib.types.number;
              default = 1.0;
              description = ''
                Rope scale for draft models.
                Same as compress_pos_emb.
                Use if the draft model was trained on long context with rope.
              '';
              example = 4.0;
            };

            draft_rope_alpha = lib.mkOption {
              type = lib.types.nullOr lib.types.number;
              default = null;
              description = ''
                Rope alpha for draft models.
                Same as alpha_value. Set to "auto" to auto-calculate.
                Leaving this null will either pull from the model or auto-calculate.
              '';
              example = 2.0;
            };

            draft_cache_mode = lib.mkOption {
              type = lib.types.str;
              default = "FP16";
              description = ''
                Cache mode for draft models to save VRAM.
                Specify the pair k_bits,v_bits where k_bits and v_bits are integers from 2-8.
                The legacy values 'FP16', 'Q8', 'Q6', 'Q4' are also accepted.
              '';
              example = "8,8";
            };

            draft_gpu_split = lib.mkOption {
              type = lib.types.listOf lib.types.number;
              default = [ ];
              description = ''
                Array of VRAM sizes to split between GPUs, in GB.
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
                Number of tokens to draft per iteration (default: draft model default)
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
                Only used when draft_mode is ngram.
              '';
              example = 3;
            };
          };

          sampling = {
            override_preset = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Select a sampler override preset.
                Find this in the sampler-overrides folder.
                This overrides default fallbacks for sampler values that are passed to the API.
                NOTE: safe_defaults provides llama.cpp-style fallbacks (temperature 0.8, top_k 40, top_p 0.95, min_p 0.05)
                for frontends that don't send sampling parameters. Leaving this null means no fallbacks at all.
                Individual overrides can also be written directly in this section;
                they apply on top
                of the preset, or on their own if no preset is given.
              '';
              example = "safe_defaults";
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
              description = ''
                List of LoRAs to load and associated scaling factors (default scale: 1.0).
              '';
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
              description = ''
                Max size of recurrent cache in system memory, in MB
              '';
              example = 8192;
            };

            sysmem_kv_cache = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 0;
              description = ''
                Size of system memory second-tier K/V cache, in MB
              '';
              example = 4096;
            };

            sysmem_multimodal_cache = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 1024;
              description = ''
                Size of the image embedding cache in system memory, in MB.
                Encoded images are kept so repeated turns of a conversation don't re-run
                the vision model. Images already in use by a request are never evicted;
                a context whose images exceed the budget is cached only partially, with
                a warning. Only applies when vision is enabled.
              '';
              example = 4096;
            };

            cuda_malloc_async = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Use the cudaMallocAsync allocator backend in Torch.
                When false, the allocator is left to the environment: unless
                PYTORCH_CUDA_ALLOC_CONF is set, ExLlamaV3 enables expandable segments in
                Torch's native allocator, which performs better than cudaMallocAsync.
                Enable this to force the cudaMallocAsync backend instead.
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
      {
        assertion =
          !(cfg.settings.model.cpu_moe_offload_layers > 0 && cfg.settings.model.cpu_moe_split_experts > 0);
        message = ''
          services.tabbyapi.settings.model.cpu_moe_offload_layers and
          services.tabbyapi.settings.model.cpu_moe_split_experts are mutually exclusive.
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

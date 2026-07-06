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
              description = "The IP to host on. Use 0.0.0.0 to expose on all adapters.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 5000;
              description = "The port to host on.";
            };

            disable_auth = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Disable HTTP token authentication. WARNING: Vulnerable if exposed.";
            };

            api_servers = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "OAI" ];
              description = "Select API servers to enable. Options: OAI, Kobold.";
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
              description = "Enable request logging. Only use for debug.";
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

            model_name = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "The initial model to load on startup. Must exist in model_dir.";
              example = "Qwen3_5-9B";
            };

            max_seq_len = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "Max sequence length. Set null to use model defaults.";
            };

            cache_mode = lib.mkOption {
              type = lib.types.str;
              default = "FP16";
              description = "Cache mode for VRAM savings. ExLlamaV2: FP16, Q8, Q6, Q4. ExLlamaV3: specific pair string (e.g., '8,8').";
            };

            gpu_split_auto = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Automatically allocate resources to GPUs.";
            };

            dummy_model_names = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "gpt-3.5-turbo" ];
              description = "List of fake model names sent via the /v1/models endpoint.";
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

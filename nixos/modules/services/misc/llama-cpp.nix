{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.llama-cpp;

  mkInstanceConfig =
    name: inst:
    let
      basePackage = inst.package;
      pkg =
        if inst.rocmGpuTargets != null then
          basePackage.override { rocmGpuTargets = inst.rocmGpuTargets; }
        else
          basePackage;

      useCuda = pkg.passthru.cudaSupport or false;
      useRocm = pkg.passthru.rocmSupport or false;
      useVulkan = pkg.passthru.vulkanSupport or false;
      needsGpu = useCuda || useRocm || useVulkan;

      deviceRules =
        lib.optionals useRocm [
          "char-drm"
          "char-kfd"
        ]
        ++ lib.optionals useCuda [
          "char-nvidiactl"
          "char-nvidia-caps"
          "char-nvidia-frontend"
          "char-nvidia-uvm"
        ]
        ++ lib.optionals useVulkan [ "char-drm" ];

      gpuGroups = [
        "video"
        "render"
      ];
    in
    {
      inherit
        pkg
        needsGpu
        deviceRules
        gpuGroups
        ;
    };

  instanceModule =
    { name, config, ... }:
    {
      options = {
        enable = lib.mkEnableOption "this llama-cpp instance";

        package = lib.mkPackageOption pkgs "llama-cpp" { };

        rocmGpuTargets = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          example = [
            "gfx906"
            "gfx1102"
          ];
          description = ''
            AMD ROCm GPU architectures to target. When set, overrides the package's
            default GPU targets for faster, architecture-specific builds.

            Common targets:
            - `gfx906`: AMD MI50, MI60
            - `gfx908`: AMD MI100
            - `gfx90a`: AMD MI210, MI250, MI250X
            - `gfx942`: AMD MI300A, MI300X, MI325X
            - `gfx1030`: Radeon PRO W6800, Radeon PRO V620
            - `gfx1100`: Radeon RX 7900 XTX, Radeon RX 7900 XT
            - `gfx1101`: Radeon RX 7800 XT, Radeon RX 7700 XT
            - `gfx1102`: Radeon PRO W7500, Radeon PRO W7600
            - `gfx1200`: Radeon RX 9060 XT
            - `gfx1201`: Radeon RX 9070 XT, Radeon RX 9070
          '';
        };

        model = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/models/llama-3.1-8b-instruct-q4_k_m.gguf";
          description = ''
            Path to the GGUF model file.

            Popular models include:
            - Llama 3.1/3.2/3.3 (Meta)
            - Qwen 2.5/3 (Alibaba)
            - Mistral/Mixtral (Mistral AI)
            - Phi-3/4 (Microsoft)
            - Gemma 2 (Google)

            Browse GGUF models at <https://huggingface.co/models?library=gguf>

            Alternatively, use `hfRepo` and `hfFile` to download models
            automatically from Hugging Face.
          '';
        };

        modelsDir = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/models/";
          description = "Models directory.";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          example = "0.0.0.0";
          description = "IP address the server listens on.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "Listen port for the server.";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Open the firewall port for this instance.";
        };

        gpuLayers = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          example = 35;
          description = ''
            Number of layers to offload to GPU (--gpu-layers).

            When null (default), automatically set to 99 if the package has GPU
            support enabled (ROCm, CUDA, or Vulkan), or 0 for CPU-only packages.
            This auto-detection is recommended for most users.

            llama.cpp clamps this value to the model's actual layer count, so 99
            effectively means "offload all layers to GPU". You can override with
            a specific value for partial offloading when VRAM is limited.
          '';
        };

        contextSize = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          example = 4096;
          description = "Context size (--ctx-size).";
        };

        parallel = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Number of server slots / concurrent requests (--parallel).";
        };

        threads = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "CPU threads for generation (--threads).";
        };

        threadsHttp = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Threads for HTTP request handling (--threads-http).";
        };

        batchSize = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Logical batch size for prompt processing (--batch-size).";
        };

        flashAttention = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "on"
              "off"
              "auto"
            ]
          );
          default = null;
          description = "Flash Attention mode (--flash-attn).";
        };

        mlock = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Lock model in RAM to prevent swap (--mlock).";
        };

        numa = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "distribute"
              "isolate"
              "numactl"
            ]
          );
          default = null;
          description = "NUMA optimization strategy (--numa).";
        };

        splitMode = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "none"
              "layer"
              "row"
            ]
          );
          default = null;
          description = "GPU split strategy (--split-mode).";
        };

        mainGpu = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Primary GPU index (--main-gpu).";
        };

        tensorSplit = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "3,1";
          description = "GPU memory ratio for tensor splitting (--tensor-split).";
        };

        alias = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Model name in REST API responses (--alias).";
        };

        chatTemplate = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Override the model's chat template (--chat-template).";
        };

        timeout = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Server read/write timeout in seconds (--timeout).";
        };

        slots = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Expose slot monitoring endpoint. Set false for --no-slots.";
        };

        embedding = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Dedicated embedding service mode (--embedding).";
        };

        enableMetrics = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Prometheus-compatible metrics endpoint (--metrics).";
        };

        apiKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            API key for authentication. Mutually exclusive with apiKeyFile.

            WARNING: This value is stored in the world-readable Nix store.
            For production use, prefer apiKeyFile with a secrets manager.
          '';
        };

        apiKeyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to a file containing the API key. Mutually exclusive with apiKey.";
        };

        sslKeyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "PEM-encoded SSL private key for HTTPS (--ssl-key-file).";
        };

        sslCertFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "PEM-encoded SSL certificate for HTTPS (--ssl-cert-file).";
        };

        lora = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "LoRA adapter paths. Each entry adds a --lora flag.";
        };

        logFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Log to file instead of journal (--log-file).";
        };

        logVerbosity = lib.mkOption {
          type = lib.types.nullOr (lib.types.ints.between 0 4);
          default = null;
          example = 4;
          description = ''
            Log verbosity level (--log-verbosity). When null, logging is disabled.
            Values: 0 = generic, 1 = info, 2 = warnings, 3 = errors, 4 = debug.
          '';
        };

        hfRepo = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "Qwen/Qwen2.5-3B-Instruct-GGUF";
          description = "HuggingFace model repo (--hf-repo).";
        };

        hfFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "qwen2.5-3b-instruct-q4_k_m.gguf";
          description = "Specific file from HuggingFace repo (--hf-file).";
        };

        extraFlags = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "--rope-scaling"
            "yarn"
          ];
          description = "Extra flags passed to llama-server.";
        };

        environment = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          example = {
            ROCR_VISIBLE_DEVICES = "0";
          };
          description = "Extra environment variables passed to the service.";
        };
      };
    };

  # Filter to only enabled instances
  enabledInstances = lib.filterAttrs (_: inst: inst.enable) cfg.instances;

  llama-cpp-verify = pkgs.writeShellApplication {
    name = "llama-cpp-verify";
    runtimeInputs = with pkgs; [
      curl
      jq
      systemd
    ];
    bashOptions = [
      "nounset"
      "pipefail"
    ];
    text = ''
      # Instance data baked in at eval time (name:host:port:metrics:slots)
      INSTANCES=(
        ${lib.concatStringsSep "\n        " (
          lib.mapAttrsToList (
            name: inst:
            let
              connectHost = if inst.host == "0.0.0.0" then "127.0.0.1" else inst.host;
            in
            ''"${name}:${connectHost}:${toString inst.port}:${lib.boolToString inst.enableMetrics}:${lib.boolToString inst.slots}"''
          ) enabledInstances
        )}
      )

      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[0;33m'
      BOLD='\033[1m'
      NC='\033[0m'

      PASS=0
      FAIL=0
      WARN=0
      DO_INFERENCE=false

      for arg in "$@"; do
        case "$arg" in
          --inference) DO_INFERENCE=true ;;
          *) echo "Usage: llama-cpp-verify [--inference]"; exit 1 ;;
        esac
      done

      pass() { echo -e "  ''${GREEN}PASS''${NC} $1"; PASS=$((PASS + 1)); }
      fail() { echo -e "  ''${RED}FAIL''${NC} $1"; FAIL=$((FAIL + 1)); }
      warn() { echo -e "  ''${YELLOW}WARN''${NC} $1"; WARN=$((WARN + 1)); }

      check_service() {
        local svc="llama-cpp-$1.service"
        if systemctl is-active --quiet "$svc"; then
          pass "systemd service $svc is active"
        else
          fail "systemd service $svc is not active"
        fi
      }

      check_health() {
        local url="http://$2:$3/health"
        local resp
        if resp=$(curl -sf --max-time 5 --connect-timeout 2 "$url" 2>/dev/null); then
          local status
          status=$(echo "$resp" | jq -r '.status // empty' 2>/dev/null)
          if [ "$status" = "ok" ]; then
            pass "/health ($url) status=ok"
          else
            warn "/health ($url) responded but status='$status'"
          fi
        else
          fail "/health ($url) unreachable"
        fi
      }

      check_metrics() {
        if [ "$4" != "true" ]; then return; fi
        local url="http://$2:$3/metrics"
        if curl -sf --max-time 5 --connect-timeout 2 "$url" >/dev/null 2>&1; then
          pass "/metrics ($url) reachable"
        else
          fail "/metrics ($url) unreachable"
        fi
      }

      check_slots() {
        if [ "$4" != "true" ]; then return; fi
        local url="http://$2:$3/slots"
        if curl -sf --max-time 5 --connect-timeout 2 "$url" >/dev/null 2>&1; then
          pass "/slots ($url) reachable"
        else
          fail "/slots ($url) unreachable"
        fi
      }

      check_security() {
        local svc="llama-cpp-$1.service"
        local output
        if output=$(systemd-analyze security --no-pager "$svc" 2>/dev/null | tail -1); then
          if [ -n "$output" ]; then
            pass "security: $output"
          else
            warn "could not read security score for $svc"
          fi
        else
          warn "systemd-analyze security failed for $svc"
        fi
      }

      check_inference() {
        if [ "$DO_INFERENCE" != "true" ]; then return; fi
        local url="http://$2:$3/v1/chat/completions"
        local resp
        if resp=$(curl -sf --max-time 30 --connect-timeout 2 \
          -H "Content-Type: application/json" \
          -d '{"messages":[{"role":"user","content":"Say hello in one word."}],"max_tokens":16}' \
          "$url" 2>/dev/null); then
          local content
          content=$(echo "$resp" | jq -r '.choices[0].message.content // empty' 2>/dev/null)
          if [ -n "$content" ]; then
            pass "inference ($url): $(echo "$content" | head -c 60)"
          else
            fail "inference ($url): empty response"
          fi
        else
          fail "inference ($url): request failed"
        fi
      }

      echo -e "''${BOLD}llama-cpp instance verification''${NC}"
      echo -e "Instances: ''${#INSTANCES[@]}\n"

      for entry in "''${INSTANCES[@]}"; do
        IFS=: read -r name host port metrics slots <<< "$entry"
        echo -e "''${BOLD}[$name]''${NC} http://$host:$port"
        check_service "$name"
        check_health "$name" "$host" "$port"
        check_metrics "$name" "$host" "$port" "$metrics"
        check_slots "$name" "$host" "$port" "$slots"
        check_security "$name"
        check_inference "$name" "$host" "$port"
        echo
      done

      echo -e "''${BOLD}Summary:''${NC} ''${GREEN}$PASS passed''${NC}, ''${RED}$FAIL failed''${NC}, ''${YELLOW}$WARN warnings''${NC}"
      if [ "$FAIL" -gt 0 ]; then
        exit 1
      fi
    '';
  };

in
{
  options.services.llama-cpp = {
    instances = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule instanceModule);
      default = { };
      description = "Named llama-cpp server instances.";
      example = lib.literalExpression ''
        {
          main = {
            enable = true;
            port = 8090;
            rocmGpuTargets = [ "gfx906" ];
            hfRepo = "Qwen/Qwen2.5-3B-Instruct-GGUF";
            environment.ROCR_VISIBLE_DEVICES = "1";
          };
        }
      '';
    };
  };

  config = lib.mkIf (enabledInstances != { }) {
    assertions = lib.flatten (
      lib.mapAttrsToList (name: inst: [
        {
          assertion = !(inst.apiKey != null && inst.apiKeyFile != null);
          message = "services.llama-cpp.instances.${name}: apiKey and apiKeyFile are mutually exclusive.";
        }
        {
          assertion = !(inst.sslKeyFile != null && inst.sslCertFile == null);
          message = "services.llama-cpp.instances.${name}: sslKeyFile requires sslCertFile.";
        }
        {
          assertion = !(inst.sslCertFile != null && inst.sslKeyFile == null);
          message = "services.llama-cpp.instances.${name}: sslCertFile requires sslKeyFile.";
        }
      ]) enabledInstances
    );

    systemd.services = lib.mapAttrs' (
      name: inst:
      let
        instCfg = mkInstanceConfig name inst;
        pkg = instCfg.pkg;
        needsGpu = instCfg.needsGpu;
        deviceRules = instCfg.deviceRules;
        gpuGroups = instCfg.gpuGroups;
        serviceName = "llama-cpp-${name}";

        # Auto-detect gpuLayers: 99 for GPU packages, 0 for CPU-only
        effectiveGpuLayers =
          if inst.gpuLayers != null then
            inst.gpuLayers
          else if needsGpu then
            99
          else
            0;
      in
      lib.nameValuePair serviceName {
        description = "LLaMA C++ server (${name})";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          HOME = "/var/cache/${serviceName}";
        }
        // inst.environment;

        serviceConfig = {
          Type = "idle";
          KillSignal = "SIGINT";
          Restart = "on-failure";
          RestartSec = 300;

          ExecStart = utils.escapeSystemdExecArgs (
            [ (lib.getExe' pkg "llama-server") ]
            ++ (
              if inst.logVerbosity != null then
                [
                  "--log-verbosity"
                  (toString inst.logVerbosity)
                ]
              else
                [ "--log-disable" ]
            )
            ++ [
              "--host"
              inst.host
              "--port"
              (toString inst.port)
            ]
            ++ lib.optionals (inst.model != null) [
              "--model"
              (toString inst.model)
            ]
            ++ lib.optionals (inst.modelsDir != null) [
              "--models-dir"
              (toString inst.modelsDir)
            ]
            ++ [
              "--gpu-layers"
              (toString effectiveGpuLayers)
            ]
            ++ lib.optionals (inst.contextSize != null) [
              "--ctx-size"
              (toString inst.contextSize)
            ]
            ++ lib.optionals (inst.parallel != null) [
              "--parallel"
              (toString inst.parallel)
            ]
            ++ lib.optionals (inst.threads != null) [
              "--threads"
              (toString inst.threads)
            ]
            ++ lib.optionals (inst.threadsHttp != null) [
              "--threads-http"
              (toString inst.threadsHttp)
            ]
            ++ lib.optionals (inst.batchSize != null) [
              "--batch-size"
              (toString inst.batchSize)
            ]
            ++ lib.optionals (inst.flashAttention != null) [
              "--flash-attn"
              inst.flashAttention
            ]
            ++ lib.optionals inst.mlock [ "--mlock" ]
            ++ lib.optionals (inst.numa != null) [
              "--numa"
              inst.numa
            ]
            ++ lib.optionals (inst.splitMode != null) [
              "--split-mode"
              inst.splitMode
            ]
            ++ lib.optionals (inst.mainGpu != null) [
              "--main-gpu"
              (toString inst.mainGpu)
            ]
            ++ lib.optionals (inst.tensorSplit != null) [
              "--tensor-split"
              inst.tensorSplit
            ]
            ++ lib.optionals (inst.alias != null) [
              "--alias"
              inst.alias
            ]
            ++ lib.optionals (inst.chatTemplate != null) [
              "--chat-template"
              inst.chatTemplate
            ]
            ++ lib.optionals (inst.timeout != null) [
              "--timeout"
              (toString inst.timeout)
            ]
            ++ lib.optionals (!inst.slots) [ "--no-slots" ]
            ++ lib.optionals inst.embedding [ "--embedding" ]
            ++ lib.optionals inst.enableMetrics [ "--metrics" ]
            ++ lib.optionals (inst.apiKey != null) [
              "--api-key"
              inst.apiKey
            ]
            ++ lib.optionals (inst.apiKeyFile != null) [
              "--api-key-file"
              (toString inst.apiKeyFile)
            ]
            ++ lib.optionals (inst.sslKeyFile != null) [
              "--ssl-key-file"
              (toString inst.sslKeyFile)
            ]
            ++ lib.optionals (inst.sslCertFile != null) [
              "--ssl-cert-file"
              (toString inst.sslCertFile)
            ]
            ++ lib.concatMap (l: [
              "--lora"
              l
            ]) inst.lora
            ++ lib.optionals (inst.logFile != null) [
              "--log-file"
              (toString inst.logFile)
            ]
            ++ lib.optionals (inst.hfRepo != null) [
              "--hf-repo"
              inst.hfRepo
            ]
            ++ lib.optionals (inst.hfFile != null) [
              "--hf-file"
              inst.hfFile
            ]
            ++ inst.extraFlags
          );

          StateDirectory = serviceName;
          CacheDirectory = serviceName;

          # GPU requires device access. PrivateDevices=true would hide /dev entirely;
          # instead use DevicePolicy=closed + DeviceAllow for cgroup-based filtering.
          PrivateDevices = !needsGpu;
        }
        // lib.optionalAttrs needsGpu {
          DevicePolicy = "closed";
          DeviceAllow = lib.unique deviceRules;
          SupplementaryGroups = lib.unique gpuGroups;
        }
        // {
          DynamicUser = true;
          UMask = "0077";
          CapabilityBoundingSet = "";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
          RemoveIPC = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter =
            if needsGpu then
              [
                "@system-service @resources"
                "~@privileged"
              ]
            else
              [
                "@system-service"
                "~@privileged"
              ];
          SystemCallErrorNumber = "EPERM";
          ProtectProc = "invisible";
          ProtectHostname = true;
          ProcSubset = if needsGpu then "all" else "pid";
        }
        // lib.optionalAttrs (inst.model != null) {
          ReadOnlyPaths = [ (toString inst.model) ];
        };
      }
    ) enabledInstances;

    networking.firewall.allowedTCPPorts = lib.mapAttrsToList (_: inst: inst.port) (
      lib.filterAttrs (_: inst: inst.openFirewall) enabledInstances
    );

    environment.systemPackages = [ llama-cpp-verify ];

  };

  meta.maintainers = with lib.maintainers; [
    newam
    randomizedcoder
  ];
}

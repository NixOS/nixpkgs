{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.llama-swap;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;

  # Options shared between the backend defaults layer and individual models.
  # At the backend level they get real `mkOption` defaults.
  # In each model, backend-level values are pushed in via `mkDefault` so
  # explicit per-model assignments (normal priority) naturally win.
  sharedOptions = {
    package = lib.mkOption {
      type = lib.types.package;
      defaultText = lib.literalExpression "pkgs.llama-cpp";
      description = ''
        The llama-cpp package to use.
      '';
    };

    ctxSize = lib.mkOption {
      type = lib.types.ints.positive;
      defaultText = lib.literalExpression "8192";
      description = ''
        Context size (`-c` / `--ctx-size`) passed to `llama-server`.
      '';
    };

    gpuLayers = lib.mkOption {
      type = lib.types.ints.u8; # 0-255
      defaultText = lib.literalExpression "0";
      description = ''
        Number of layers to offload to the GPU (`-ngl`).
        Set to 0 for CPU-only inference.
      '';
    };

    threads = lib.mkOption {
      type = lib.types.ints.positive;
      defaultText = lib.literalExpression "4";
      description = ''
        Number of CPU threads for inference (`--threads`).
      '';
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--temp"
        "0.2"
        "--top-k"
        "9"
      ];
      description = ''
        Extra command-line flags to append to the generated
        `llama-server` invocation.
      '';
    };

    aliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional model names that route to this backend.
      '';
    };

    concurrencyLimit = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      description = ''
        Maximum number of concurrent requests before queuing.
        When `null`, no limit is set.
      '';
    };
  };
in
{
  options.services.llama-swap = {
    enable = lib.mkEnableOption "the llama-swap service";

    package = lib.mkPackageOption pkgs "llama-swap" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      example = "0.0.0.0";
      description = ''
        Address that llama-swap listens on.
      '';
    };

    port = lib.mkOption {
      default = 8080;
      example = 11343;
      type = lib.types.port;
      description = ''
        Port that llama-swap listens on.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for llama-swap.
        This adds {option}`port` to [](#opt-networking.firewall.allowedTCPPorts).
      '';
    };

    tls = {
      enable = lib.mkEnableOption "TLS encryption";

      certFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/path/to/cert.pem";
        description = ''
          Path to the TLS certificate file. This certificate will be offered to,
          and may be verified by, clients.
        '';
      };

      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/path/to/key.pem";
        description = ''
          Path to the TLS private key file. This key will be used to decrypt,
          data received from clients.
        '';
      };
    };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      description = ''
        llama-swap configuration. Refer to the [llama-swap example configuration](https://github.com/mostlygeek/llama-swap/blob/main/config.example.yaml)
        for details on supported values.
      '';
      example = lib.literalExpression ''
        let
          llama-cpp = pkgs.llama-cpp.override { rocmSupport = true; };
          llama-server = lib.getExe' llama-cpp "llama-server";
        in
        {
          healthCheckTimeout = 60;
          models = {
            "some-model" = {
              cmd = "''${llama-server} --port ''${PORT} -m /var/lib/llama-cpp/models/some-model.gguf -ngl 0 --no-webui";
              aliases = [
                "the-best"
              ];
            };
            "other-model" = {
              proxy = "http://127.0.0.1:5555";
              cmd = "''${llama-server} --port 5555 -m /var/lib/llama-cpp/models/other-model.gguf -ngl 0 -c 4096 -np 4 --no-webui";
              concurrencyLimit = 4;
            };
          };
        };
      '';
    };

    backends.llama-cpp = lib.mkOption {
      description = ''
        Declarative llama.cpp backend configuration. Set defaults at this
        level (e.g. `gpuLayers`, `threads`) and they will apply to all models
        unless overridden.

        Individual models are defined under {option}`models` and are converted
        into {option}`settings.models` automatically, so both can be used
        alongside each other.

        Unlike {option}`settings.models`, which requires manually writing the
        full `cmd` string, backends let you specify the model path and common
        flags as structured Nix values.
      '';
      example = lib.literalExpression ''
        {
          # Backend-level defaults
          gpuLayers = 0;
          threads = 4;

          models = {
            qwen = {
              model = ./models/qwen3.gguf;
              ctxSize = 32768;
            };
            llama = {
              model = ./models/llama3.gguf;
              # inherits gpuLayers and threads from above
              aliases = [ "llama-fallback" ];
            };
          };
        }
      '';
      type = lib.types.submodule (
        { config, ... }:
        let
          # After module resolution, `config` here has all backend-level
          # values filled in. Push them into each model at mkDefault priority
          # (1200) so explicit per-model assignments (1000) win.
          backendDefaults = {
            package = lib.mkDefault config.package;
            ctxSize = lib.mkDefault config.ctxSize;
            gpuLayers = lib.mkDefault config.gpuLayers;
            threads = lib.mkDefault config.threads;
            extraFlags = lib.mkDefault config.extraFlags;
            aliases = lib.mkDefault config.aliases;
            concurrencyLimit = lib.mkDefault config.concurrencyLimit;
          };
        in
        {
          options = sharedOptions // {
            settings = settingsOption ''
              Global llama-server CLI flags. Keys are long-form flag
              names without dashes. These become defaults for all
              models.

              Bool values map to flags: `true` → `--flag`, `false` →
              (omitted). Use negated flag names for `--no-...` flags
              (e.g. `no-webui = true;` → `--no-webui`).
            '';

            models = lib.mkOption {
              default = { };
              description = ''
                Individual model definitions. Each attribute becomes a model
                served by a `llama-server` instance. Inherited defaults from
                the backend level can be overridden per-model.
              '';
              type = lib.types.attrsOf (
                lib.types.submodule (
                  { config, ... }:
                  {
                    options = sharedOptions // {
                      model = lib.mkOption {
                        type = lib.types.path;
                        description = ''
                          Path to the GGUF model file.
                        '';
                      };
                    };

                    config = backendDefaults;
                  }
                )
              );
            };
          };

          # Backend-level defaults
          config = {
            package = lib.mkDefault pkgs.llama-cpp;
            ctxSize = lib.mkDefault 8192;
            gpuLayers = lib.mkDefault 0;
            threads = lib.mkDefault 4;
          };
        }
      );
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.tls.enable -> cfg.tls.certFile != null;
        message = "Please provide a certificate to use for TLS encryption.";
      }
      {
        assertion = cfg.tls.enable -> cfg.tls.keyFile != null;
        message = "Please provide a private key to use for TLS encryption.";
      }
    ];

    systemd.services.llama-swap = {
      description = "Model swapping for LLaMA C++ Server (or any local OpenAPI compatible server)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = rec {
        XDG_CACHE_HOME = "/var/cache/${config.systemd.services.llama-swap.serviceConfig.CacheDirectory}";
        LLAMA_CACHE = "${XDG_CACHE_HOME}/huggingface/hub";
      };

      serviceConfig = {
        Type = "exec";
        ExecStart = "${lib.getExe cfg.package} ${
          lib.escapeShellArgs (
            [
              "--listen=${cfg.listenAddress}:${toString cfg.port}"
              "--config=${configFile}"
            ]
            ++ lib.optionals cfg.tls.enable [
              "--tls-cert-file=${cfg.tls.certFile}"
              "--tls-key-file=${cfg.tls.keyFile}"
            ]
          )
        }";
        Restart = "on-failure";
        RestartSec = 3;

        CacheDirectory = "llama-swap";

        # for GPU acceleration
        PrivateDevices = false;

        # hardening
        DynamicUser = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        NoNewPrivileges = true;
        PrivateMounts = true;
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
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        SystemCallErrorNumber = "EPERM";
        ProtectProc = "invisible";
        ProtectHostname = true;
        WorkingDirectory = "/tmp";
      };
    };
    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta.maintainers = with lib.maintainers; [
    jk
    podium868909
  ];
}

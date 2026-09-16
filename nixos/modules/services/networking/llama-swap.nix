{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.llama-swap;
  settingsFormat = pkgs.formats.yaml { };

  settingsValueType = lib.types.oneOf [
    lib.types.bool
    lib.types.int
    lib.types.float
    lib.types.str
    lib.types.path
  ];

  # Convert a settings attrset to llama-server CLI arguments.
  # Uses lib.cli.toCommandLine with explicitBool = false so:
  #   true  → --flag
  #   false → (omitted)
  # This matches llama-server's convention where negation is done via
  # --no-flag (e.g. settings."no-webui" = true → --no-webui).
  settingsToFlags =
    settings:
    lib.cli.toCommandLine (optionName: {
      option = "--${optionName}";
      sep = null;
      explicitBool = false;
    }) settings;

  # This is extracted here so it can be reused when setting global and model specific settings
  sharedOptions = {
    package = lib.mkOption {
      type = lib.types.package;
      defaultText = lib.literalExpression "pkgs.llama-cpp";
      description = ''
        The llama-cpp package to use.
      '';
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--verbose" ];
      description = ''
        Extra `llama-server` CLI flags appended after the generated
        arguments. Escape hatch for flags that should not live in
        {option}`settings`.
      '';
    };

    swapSettings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      example = {
        ttl = 300;
        aliases = [ "llama-fallback" ];
        env = [ "CUDA_VISIBLE_DEVICES=0" ];
      };
      description = ''
        Extra llama-swap model keys (`ttl`, `aliases`, `env`, `description`,
        `filters`, `metadata`, `concurrencyLimit`, …). Merged into
        {option}`settings.models.<name>`.

        `cmd` is generated and cannot be set here.
      '';
    };
  };

  # This freeform `settings` option is used when setting global and model specific settings.
  # Keys are llama-server long-form CLI flag names (without leading dashes).
  settingsOption =
    description:
    lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (lib.types.nullOr settingsValueType);
      };
      default = { };
      inherit description;
    };

  generatedModels = lib.mapAttrs (
    _: modelCfg:
    let
      # Merge backend-level and model-level settings. Model-level values
      # (normal priority 1000) win over backend-level mkDefault (1200).
      mergedSettings = cfg.backends.llama-cpp.settings // modelCfg.settings;
      args =
        settingsToFlags mergedSettings
        ++ [
          "--port"
          "\${PORT}"
        ]
        ++ modelCfg.extraFlags;
    in
    cfg.backends.llama-cpp.swapSettings
    // modelCfg.swapSettings
    // {
      cmd = "${lib.getExe' modelCfg.package "llama-server"} ${lib.escapeShellArgs args}";
    }
  ) cfg.backends.llama-cpp.models;

  configFile = settingsFormat.generate "config.yaml" (
    lib.recursiveUpdate cfg.settings { models = (cfg.settings.models or { }) // generatedModels; }
  );
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
              cmd = "''${llama-server} --port ''${PORT} -m /var/lib/llama-cpp/models/some-model.gguf -ngl 0";
              aliases = [
                "the-best"
              ];
            };
          };
        };
      '';
      default = { };
    };

    backends.llama-cpp = lib.mkOption {
      description = ''
        Declarative llama.cpp backend configuration.

        {option}`settings` is a freeform attrset of llama-server CLI flags
        (without leading dashes). Backend-level values become defaults for all
        models; per-model {option}`models.<name>.settings` override them.

        Each model is launched as:

        `llama-server <flags from settings> --port ''${PORT}`

        so llama-swap can inject the listen port. Do not set `port` or `host`
        in {option}`settings` — they are reserved.

        Generated models are merged into {option}`settings.models`, so raw
        `cmd` entries and declarative backends can be used together.

        Use {option}`swapSettings` for llama-swap model-level options like
        `ttl`, `aliases`, `env`, etc.
      '';
      example = lib.literalExpression ''
        {
          # Backend-level defaults
          settings = {
            "n-gpu-layers" = 99;
            "threads" = 4;
          };

          swapSettings.ttl = 300;

          models = {
            qwen = {
              settings = {
                model = "./models/qwen3.gguf";
                "ctx-size" = 32768;
              };
            };
            llama = {
              settings.model = "./models/llama3.gguf";
              # inherits n-gpu-layers and threads from above
              swapSettings.aliases = [ "llama-fallback" ];
            };
          };
        }
      '';
      type = lib.types.submodule (
        { config, ... }:
        let
          # Push global settings into each model at mkDefault priority
          # Explicit per-model assignments win.
          backendNixDefaults = {
            package = lib.mkDefault config.package;
            extraFlags = lib.mkDefault config.extraFlags;
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
                Individual model definitions. Each attribute becomes a
                llama-swap model whose `cmd` is generated from
                {option}`settings`.
              '';
              type = lib.types.attrsOf (
                lib.types.submodule {
                  options = sharedOptions // {
                    settings = settingsOption ''
                      Per-model llama-server CLI flags. Overrides
                      {option}`backends.llama-cpp.settings`.
                    '';
                  };

                  config = backendNixDefaults;
                }
              );
            };
          };

          # Backend-level defaults
          config = {
            package = lib.mkDefault pkgs.llama-cpp;
          };
        }
      );
      default = { };
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
      {
        assertion = !(cfg.backends.llama-cpp.swapSettings ? cmd);
        message = ''
          services.llama-swap.backends.llama-cpp.swapSettings.cmd is reserved;
          the command is generated from settings.
        '';
      }
      {
        assertion = !(cfg.backends.llama-cpp.settings ? port || cfg.backends.llama-cpp.settings ? host);
        message = ''
          services.llama-swap.backends.llama-cpp.settings must not set 'port' or 'host'.
          llama-swap injects --port ''${PORT} on the generated command.
        '';
      }
    ]
    ++ lib.mapAttrsToList (name: modelCfg: {
      assertion = !(modelCfg.swapSettings ? cmd);
      message = ''
        services.llama-swap.backends.llama-cpp.models.${name}.swapSettings.cmd
        is reserved; the command is generated from settings. Use
        services.llama-swap.settings.models.${name}.cmd for a fully hand-written
        backend instead.
      '';
    }) cfg.backends.llama-cpp.models
    ++ lib.mapAttrsToList (name: modelCfg: {
      assertion = !(modelCfg.settings ? port || modelCfg.settings ? host);
      message = ''
        services.llama-swap.backends.llama-cpp.models.${name}.settings must not
        set 'port' or 'host'. llama-swap injects --port ''${PORT} on the
        generated command.
      '';
    }) cfg.backends.llama-cpp.models;

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

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [
    jk
    podium868909
  ];
}

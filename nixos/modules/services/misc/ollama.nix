{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) literalExpression types mkBefore;

  cfg = config.services.ollama;
  ollamaPackage = cfg.package.override { inherit (cfg) acceleration; };

  staticUser = cfg.user != null && cfg.group != null;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "ollama"
      "listenAddress"
    ] "Use `services.ollama.host` and `services.ollama.port` instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "ollama"
      "sandbox"
    ] "Set `services.ollama.user` and `services.ollama.group` instead.")
    (lib.mkRemovedOptionModule
      [
        "services"
        "ollama"
        "writablePaths"
      ]
      "The `models` directory is now always writable. To make other directories writable, use `systemd.services.ollama.serviceConfig.ReadWritePaths`."
    )
  ];

  options = {
    services.ollama = {
      enable = lib.mkEnableOption "ollama server for local large language models";
      package = lib.mkPackageOption pkgs "ollama" { };

      user = lib.mkOption {
        type = with types; nullOr str;
        default = null;
        example = "ollama";
        description = ''
          User account under which to run ollama. Defaults to [`DynamicUser`](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#DynamicUser=)
          when set to `null`.

          The user will automatically be created, if this option is set to a non-null value.
        '';
      };

      group = lib.mkOption {
        type = with types; nullOr str;
        default = cfg.user;
        defaultText = literalExpression "config.services.ollama.user";
        example = "ollama";
        description = ''
          Group under which to run ollama. Only used when `services.ollama.user` is set.

          The group will automatically be created, if this option is set to a non-null value.
        '';
      };

      home = lib.mkOption {
        type = types.str;
        default = "/var/lib/ollama";
        example = "/home/foo";
        description = ''
          The home directory that the ollama service is started in.
        '';
      };

      models = lib.mkOption {
        type = types.str;
        default = "${cfg.home}/models";
        defaultText = "\${config.services.ollama.home}/models";
        example = "/path/to/ollama/models";
        description = ''
          The directory that the ollama service will read models from and download new models to.
        '';
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "[::]";
        description = ''
          The host address which the ollama server HTTP interface listens to.
        '';
      };
      port = lib.mkOption {
        type = types.port;
        default = 11434;
        example = 11111;
        description = ''
          Which port the ollama server listens to.
        '';
      };
      acceleration = lib.mkOption {
        type = types.nullOr (
          types.enum [
            false
            "rocm"
            "cuda"
          ]
        );
        default = null;
        example = "rocm";
        description = ''
          What interface to use for hardware acceleration.

          - `null`: default behavior
            - if `nixpkgs.config.rocmSupport` is enabled, uses `"rocm"`
            - if `nixpkgs.config.cudaSupport` is enabled, uses `"cuda"`
            - otherwise defaults to `false`
          - `false`: disable GPU, only use CPU
          - `"rocm"`: supported by most modern AMD GPUs
            - may require overriding gpu type with `services.ollama.rocmOverrideGfx`
              if rocm doesn't detect your AMD gpu
          - `"cuda"`: supported by most modern NVIDIA GPUs
        '';
      };
      rocmOverrideGfx = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "10.3.0";
        description = ''
          Override what rocm will detect your gpu model as.
          For example, make rocm treat your RX 5700 XT (or any other model)
          as an RX 6900 XT using a value of `"10.3.0"` (gfx 1030).

          This sets the value of `HSA_OVERRIDE_GFX_VERSION`. See [ollama's docs](
          https://github.com/ollama/ollama/blob/main/docs/gpu.md#amd-radeon
          ) for details.
        '';
      };
      environmentVariables = lib.mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          OLLAMA_LLM_LIBRARY = "cpu";
          HIP_VISIBLE_DEVICES = "0,1";
        };
        description = ''
          Set arbitrary environment variables for the ollama service.

          Be aware that these are only seen by the ollama server (systemd service),
          not normal invocations like `ollama run`.
          Since `ollama run` is mostly a shell around the ollama server, this is usually sufficient.
        '';
      };
      loadModels = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The models to download as soon as the service starts.
          Search for models of your choice from: https://ollama.com/library
        '';
      };
      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for ollama.
          This adds `services.ollama.port` to `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = lib.mkIf staticUser {
      users.${cfg.user} = {
        inherit (cfg) home;
        isSystemUser = true;
        group = cfg.group;
      };
      groups.${cfg.group} = { };
    };

    systemd.services.ollama = {
      description = "Server for local large language models";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment =
        cfg.environmentVariables
        // {
          HOME = cfg.home;
          OLLAMA_MODELS = cfg.models;
          OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
        }
        // lib.optionalAttrs (cfg.rocmOverrideGfx != null) {
          HSA_OVERRIDE_GFX_VERSION = cfg.rocmOverrideGfx;
        };
      serviceConfig =
        lib.optionalAttrs staticUser {
          User = cfg.user;
          Group = cfg.group;
        }
        // {
          DynamicUser = true;
          ExecStart = "${lib.getExe ollamaPackage} serve";
          WorkingDirectory = cfg.home;
          StateDirectory = [ "ollama" ];
          ReadWritePaths = [
            cfg.home
            cfg.models
          ];

          CapabilityBoundingSet = [ "" ];
          DeviceAllow = [
            # CUDA
            # https://docs.nvidia.com/dgx/pdf/dgx-os-5-user-guide.pdf
            "char-nvidiactl"
            "char-nvidia-caps"
            "char-nvidia-frontend"
            "char-nvidia-uvm"
            # ROCm
            "char-drm"
            "char-kfd"
          ];
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = false; # hides acceleration devices
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "all"; # /proc/meminfo
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          SupplementaryGroups = [ "render" ]; # for rocm to access /dev/dri/renderD* devices
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service @resources"
            "~@privileged"
          ];
          UMask = "0077";
        };
      postStart = mkBefore ''
        set -x
        export OLLAMA_HOST=${lib.escapeShellArg cfg.host}:${builtins.toString cfg.port}
        for model in ${lib.escapeShellArgs cfg.loadModels}
        do
          ${lib.escapeShellArg (lib.getExe ollamaPackage)} pull "$model"
        done
      '';
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    environment.systemPackages = [ ollamaPackage ];
  };

  meta.maintainers = with lib.maintainers; [
    abysssol
    onny
  ];
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) literalExpression types;

  cfg = config.services.ollama;
  ollama = lib.getExe cfg.package;

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
    (lib.mkRemovedOptionModule [
      "services"
      "ollama"
      "acceleration"
    ] "Set `services.ollama.package` to one of `pkgs.ollama[,-vulkan,-rocm,-cuda,-cpu]` instead.")
  ];

  options = {
    services.ollama = {
      enable = lib.mkEnableOption "ollama server for local large language models";
      package = lib.mkPackageOption pkgs "ollama" {
        example = "pkgs.ollama-rocm";
        extraDescription = ''
          Different packages use different hardware acceleration.

          - `ollama`: default behavior; usually equivalent to `ollama-cpu`
            - if `nixpkgs.config.rocmSupport` is enabled, is equivalent to `ollama-rocm`
            - if `nixpkgs.config.cudaSupport` is enabled, is equivalent to `ollama-cuda`
            - otherwise defaults to `false`
          - `ollama-cpu`: disable GPU; only use CPU
          - `ollama-rocm`: supported by most modern AMD GPUs
            - may require overriding gpu type with `services.ollama.rocmOverrideGfx`
              if rocm doesn't detect your AMD gpu
          - `ollama-cuda`: supported by most modern NVIDIA GPUs
          - `ollama-vulkan`: supported by most GPUs
        '';
      };

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

      rocmOverrideGfx = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "10.3.0";
        description = ''
          Override what rocm will detect your gpu model as.
          For example, if you have an RX 5700 XT, try setting this to `"10.1.0"` (gfx 1010).

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
        apply = builtins.filter (model: model != "");
        default = [ ];
        example = [
          "dolphin3"
          "gemma3"
          "gemma3:27b"
          "deepseek-r1:latest"
          "deepseek-r1:1.5b"
        ];
        description = ''
          Download these models using `ollama pull` as soon as `ollama.service` has started.

          This creates a systemd unit `ollama-model-loader.service`.
          Use `services.ollama.syncModels` to automatically remove any models not currently declared here.

          Search for models of your choice from: <https://ollama.com/library>
        '';
      };
      syncModels = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Synchronize all currently installed models with those declared in `services.ollama.loadModels`,
          removing any models that are installed but not currently declared there.
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
          Type = "exec";
          DynamicUser = true;
          ExecStart = "${ollama} serve";
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
            "char-fb"
            "char-kfd"
            # WSL (Windows Subsystem for Linux)
            "/dev/dxg"
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
    };

    systemd.services.ollama-model-loader = lib.mkIf (cfg.loadModels != [ ] || cfg.syncModels) {
      description = "Download ollama models in the background";
      wantedBy = [
        "multi-user.target"
        "ollama.service"
      ];
      wants = [ "network-online.target" ];
      after = [
        "ollama.service"
        "network-online.target"
      ];
      bindsTo = [ "ollama.service" ];
      environment = config.systemd.services.ollama.environment;
      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        Restart = "on-failure";
        # bounded exponential backoff
        RestartSec = "1s";
        RestartMaxDelaySec = "2h";
        RestartSteps = "10";
      };

      script =
        let
          binaryInputs = lib.mapAttrs (_: lib.getExe) {
            parallel = pkgs.parallel;
            awk = pkgs.gawk;
            sed = pkgs.gnused;
          };
          inherit (binaryInputs)
            parallel
            awk
            sed
            ;

          declaredModelsRegex = lib.pipe cfg.loadModels [
            (map lib.escapeRegex)
            (lib.concatStringsSep "|")
            (lib.escape [ "/" ])
            lib.escapeShellArg
          ];
        in
        ''
          ${lib.optionalString cfg.syncModels ''
            installed=$('${ollama}' list | '${awk}' 'NR > 1 {print $1}')
            ${
              # if `declaredModelsRegex` is empty, sed will err
              if (cfg.loadModels != [ ]) then
                ''
                  echo declared models regex: ${declaredModelsRegex}
                  undeclared=$(echo "$installed" | '${sed}' -E /${declaredModelsRegex}/d)
                ''
              else
                ''
                  undeclared="$installed"
                ''
            }
            if [ -n "$undeclared" ]; then
              echo removing: $undeclared
              '${ollama}' rm $undeclared
            fi
          ''}

          '${parallel}' --tag '${ollama}' pull ::: ${lib.escapeShellArgs cfg.loadModels}
        '';
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [
    abysssol
    onny
  ];
}

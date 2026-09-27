{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ds4;
  staticUser = cfg.user != null && cfg.group != null;

  # Build the ds4-server command line from options.
  serverArgs =
    with cfg;
    lib.concatStringsSep " " (
      lib.filter (x: x != "") [
        "-m ${lib.escapeShellArg model}"

        "--host ${host}"
        "--port ${toString port}"

        (lib.optionalString (ctx != null) "--ctx ${toString ctx}")
        (lib.optionalString (threads != null) "--threads ${toString threads}")
        (lib.optionalString (batchSize != null) "--batch-size ${toString batchSize}")
        (lib.optionalString (kvDiskDir != null) "--kv-disk-dir ${lib.escapeShellArg kvDiskDir}")
        (lib.optionalString (kvDiskSpaceMb != null) "--kv-disk-space-mb ${toString kvDiskSpaceMb}")
        (lib.optionalString noKvOffload "--no-kv-offload")
        (lib.optionalString cors "--cors")
        (lib.optionalString (gpuDeviceIds != null) "--gpu ${lib.escapeShellArg gpuDeviceIds}")
      ]
    );
in
{
  options.services.ds4 = {
    enable = lib.mkEnableOption "the ds4-server DwarfStar local inference HTTP API";

    package = lib.mkPackageOption pkgs "ds4" {
      example = "pkgs.ds4-rocm";
      extraDescription = ''
        Different packages use different backends:

        - `ds4`: CPU-only build
        - `ds4-rocm`: ROCm build (AMD GPUs, e.g. Strix Halo)
        - `ds4-cuda`: CUDA build (NVIDIA GPUs)

        The GPU variants are compiled for a specific GPU arch (see the package
        `cudaArch`/`rocmArch` options) and must be built on a machine carrying
        the matching toolchain.
      '';
    };

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "ds4";
      description = ''
        User account under which to run ds4-server. Defaults to
        [DynamicUser](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#DynamicUser=)
        when set to `null`.

        The user will automatically be created when set to a non-null value.
      '';
    };

    group = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = cfg.user;
      defaultText = lib.literalExpression "config.services.ds4.user";
      example = "ds4";
      description = ''
        Group under which to run ds4-server. Only used when `services.ds4.user`
        is set.

        The group will automatically be created when set to a non-null value.
      '';
    };

    model = lib.mkOption {
      description = "Path to the GGUF model file (e.g. ds4flash.gguf).";
      type = lib.types.str;
      example = "/var/lib/ds4/ds4flash.gguf";
    };

    host = lib.mkOption {
      description = "Address the ds4-server HTTP API binds to.";
      default = "127.0.0.1";
      example = "0.0.0.0";
      type = lib.types.str;
    };

    port = lib.mkOption {
      description = "TCP port the ds4-server HTTP API listens on.";
      default = 8000;
      type = lib.types.port;
    };

    ctx = lib.mkOption {
      description = "Maximum context length (number of tokens).";
      default = 100000;
      example = 100000;
      type = lib.types.nullOr lib.types.int;
    };

    threads = lib.mkOption {
      description = "Number of inference threads (default: CPU core count).";
      default = null;
      example = 16;
      type = lib.types.nullOr lib.types.int;
    };

    batchSize = lib.mkOption {
      description = "Token batch size for prompt processing.";
      default = null;
      example = 512;
      type = lib.types.nullOr lib.types.int;
    };

    kvDiskDir = lib.mkOption {
      description = ''
        Directory for KV cache disk offloading (persists across restarts).

        With the default dynamic user, this must be a subdirectory of
        `/var/lib/ds4` (created automatically); a `user`/`group` must be set to
        use an arbitrary path.
      '';
      default = null;
      example = "/var/lib/ds4/kv";
      type = lib.types.nullOr lib.types.str;
    };

    kvDiskSpaceMb = lib.mkOption {
      description = "Maximum disk space for KV cache offloading in MB.";
      default = null;
      example = 8192;
      type = lib.types.nullOr lib.types.int;
    };

    noKvOffload = lib.mkOption {
      description = "Disable KV cache offloading to disk entirely.";
      default = false;
      type = lib.types.bool;
    };

    cors = lib.mkOption {
      description = "Enable CORS headers for browser-based clients.";
      default = false;
      type = lib.types.bool;
    };

    gpuDeviceIds = lib.mkOption {
      description = "GPU device IDs for multi-GPU inference (e.g. '0,1').";
      default = null;
      example = "0,1";
      type = lib.types.nullOr lib.types.str;
    };

    environment = lib.mkOption {
      description = ''
        Extra environment variables for the ds4-server process. Useful for GPU
        backends — e.g. ROCm Strix Halo needs HSA_ENABLE_SDMA=0.

        Example for ROCm on Strix Halo:
        `{ HSA_ENABLE_SDMA = "0"; }`
      '';
      default = { };
      example = {
        HSA_ENABLE_SDMA = "0";
      };
      type = lib.types.attrsOf lib.types.str;
    };

    openFirewall = lib.mkOption {
      description = "Open the ds4-server port in the firewall.";
      default = false;
      type = lib.types.bool;
    };

    autoStart = lib.mkOption {
      description = ''
        Whether to start ds4-server automatically at boot.
        Set to false to only start it on demand via `systemctl start ds4-server`.
      '';
      default = true;
      type = lib.types.bool;
    };

    extraArgs = lib.mkOption {
      description = "Additional arguments to append to the ds4-server command line.";
      default = [ ];
      example = [
        "--no-mmap"
        "--log-format"
        "json"
      ];
      type = lib.types.listOf lib.types.str;
    };

    extraServiceConfig = lib.mkOption {
      description = "Extra systemd service unit config (e.g. SupplementaryGroups, TimeoutStopSec).";
      default = { };
      example = {
        SupplementaryGroups = [
          "render"
          "video"
        ];
        TimeoutStopSec = 120;
      };
      type = lib.types.attrsOf lib.types.anything;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.model != "";
        message = "services.ds4: `model` must be set to a GGUF file path.";
      }
      {
        assertion = cfg.kvDiskDir == null || staticUser || lib.hasPrefix "/var/lib/ds4" cfg.kvDiskDir;
        message = ''
          services.ds4: with the default dynamic user, `kvDiskDir` must be inside
          `/var/lib/ds4` (e.g. `/var/lib/ds4/kv`); set `services.ds4.user`/`group`
          to use an arbitrary path.
        '';
      }
    ];

    # Ensure the ds4 package is available in the system closure (for manual use).
    environment.systemPackages = [ cfg.package ];

    systemd.services.ds4-server = {
      description = "ds4-server — DwarfStar local inference HTTP API";
      documentation = [
        "https://github.com/antirez/ds4"
        "https://github.com/antirez/ds4#readme"
      ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = lib.optionals cfg.autoStart [ "multi-user.target" ];

      environment = cfg.environment;

      serviceConfig =
        lib.optionalAttrs staticUser {
          User = cfg.user;
          Group = cfg.group;
        }
        // {
          Type = "exec";
          DynamicUser = true;
          ExecStart = "${cfg.package}/bin/ds4-server ${serverArgs} ${lib.escapeShellArgs cfg.extraArgs}";
          WorkingDirectory = "/var/lib/ds4";
          StateDirectory = [ "ds4" ];
          ReadWritePaths = [ "/var/lib/ds4" ] ++ lib.optionals (cfg.kvDiskDir != null) [ cfg.kvDiskDir ];

          Restart = "on-failure";
          RestartSec = 10;
          StartLimitBurst = 3;

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
        }
        // cfg.extraServiceConfig;
    };

    systemd.tmpfiles.rules = lib.mkIf staticUser (
      (lib.optional (cfg.kvDiskDir != null) "d ${cfg.kvDiskDir} 0700 ${cfg.user} ${cfg.group} - -")
      ++ (lib.optional (lib.hasPrefix "/var/lib/ds4" cfg.model) "d /var/lib/ds4 0700 ${cfg.user} ${cfg.group} - -")
    );

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}

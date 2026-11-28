{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ds4;

  serverArgs =
    with cfg;
    lib.concatStringsSep " " (
      [
        "-m ${lib.escapeShellArg model}"
        "--host ${host}"
        "--port ${toString port}"
      ]
      ++ lib.optional (ctx != null) "--ctx ${toString ctx}"
      ++ lib.optional (threads != null) "--threads ${toString threads}"
      ++ lib.optional (batchSize != null) "--batch-size ${toString batchSize}"
      ++ lib.optional (kvDiskDir != null) "--kv-disk-dir ${lib.escapeShellArg kvDiskDir}"
      ++ lib.optional (kvDiskSpaceMb != null) "--kv-disk-space-mb ${toString kvDiskSpaceMb}"
      ++ lib.optional noKvOffload "--no-kv-offload"
      ++ lib.optional cors "--cors"
      ++ lib.optional (gpuDeviceIds != null) "--gpu ${lib.escapeShellArg gpuDeviceIds}"
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

        Each GPU variant targets a single architecture. `ds4-rocm` defaults to
        `gfx1151` (Strix Halo), and `ds4-cuda` uses the first architecture in
        `cudaPackages.flags.realArches`. To build for another GPU, use an override
        such as `pkgs.ds4-rocm.override { rocmArch = "gfx1100"; }` or
        `pkgs.ds4-cuda.override { cudaArch = "sm_120"; }`. Builds can run on a
        machine without a GPU.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "ds4";
      description = "User account under which ds4-server runs. The default account is created automatically.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "ds4";
      description = "Group under which ds4-server runs. The default group is created automatically.";
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
      type = lib.types.nullOr lib.types.ints.positive;
    };

    threads = lib.mkOption {
      description = "Number of inference threads (default: CPU core count).";
      default = null;
      example = 16;
      type = lib.types.nullOr lib.types.ints.positive;
    };

    batchSize = lib.mkOption {
      description = "Token batch size for prompt processing.";
      default = null;
      example = 512;
      type = lib.types.nullOr lib.types.ints.positive;
    };

    kvDiskDir = lib.mkOption {
      description = "Directory for KV cache disk offloading (persists across restarts).";
      default = null;
      example = "/var/lib/ds4/kv";
      type = lib.types.nullOr lib.types.str;
    };

    kvDiskSpaceMb = lib.mkOption {
      description = "Maximum disk space for KV cache offloading in MB.";
      default = null;
      example = 8192;
      type = lib.types.nullOr lib.types.ints.positive;
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
      description = "Comma-separated list of GPU device IDs to use for multi-GPU inference.";
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
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.model != "";
        message = "services.ds4: `model` must be set to a GGUF file path.";
      }
    ];

    users.users.ds4 = lib.mkIf (cfg.user == "ds4") {
      isSystemUser = true;
      group = cfg.group;
      extraGroups = [ "render" ];
      home = "/var/lib/ds4";
    };
    users.groups.ds4 = lib.mkIf (cfg.group == "ds4") { };

    environment.systemPackages = [ cfg.package ];

    systemd.services.ds4-server = {
      description = "ds4-server — DwarfStar local inference HTTP API";
      documentation = [ "https://github.com/antirez/ds4" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.environment;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "exec";
        ExecStart = "${cfg.package}/bin/ds4-server ${serverArgs} ${lib.escapeShellArgs cfg.extraArgs}";
        WorkingDirectory = "/var/lib/ds4";
        StateDirectory = [ "ds4" ];
        ReadWritePaths = lib.optional (cfg.kvDiskDir != null) cfg.kvDiskDir;

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
        SupplementaryGroups = lib.optional (cfg.user != "ds4") "render";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @resources"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };

    systemd.tmpfiles.settings."10-ds4" = lib.optionalAttrs (cfg.kvDiskDir != null) {
      ${cfg.kvDiskDir}.d = {
        inherit (cfg) user group;
        mode = "0700";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}

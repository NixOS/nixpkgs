{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.beszel.agent;

  hasVideoDriver = driver: builtins.elem driver config.services.xserver.videoDrivers;

  # Collector names must match `isValidCollectorSource` in upstream's agent/gpu.go.
  # macmon and powermetrics are macOS-only and omitted here.
  gpuCollectors = {
    # read sysfs directly, need no package or device access
    "amd_sysfs" = { };
    "intel_sysfs" = { };
    "intel_gpu_top" = {
      package = lib.getBin pkgs.intel-gpu-tools;
      deviceAllow = [ "char-drm rw" ];
      capabilities = [ "CAP_PERFMON" ];
      # perf_event_open is in @debug, not @system-service
      systemCalls = [ "perf_event_open" ];
    };
    "nvidia-smi" = {
      package = lib.getBin config.hardware.nvidia.package;
      deviceAllow = [ "char-nvidia* rw" ];
    };
    "nvml" = {
      deviceAllow = [ "char-nvidia* rw" ];
    };
    "nvtop" = {
      package = lib.getBin pkgs.nvtopPackages.full;
      deviceAllow = [
        "char-nvidia* rw"
        "char-drm rw"
      ];
    };
    "rocm-smi" = {
      package = lib.getBin pkgs.rocmPackages.rocm-smi;
      deviceAllow = [
        "char-drm rw"
        "char-kfd rw"
      ];
    };
  };

  activeCollectors = lib.optionals (!cfg.environment.SKIP_GPU) cfg.environment.GPU_COLLECTOR;

  collectorAttrs =
    attr: lib.unique (lib.concatMap (name: gpuCollectors.${name}.${attr} or [ ]) activeCollectors);

  gpuPackages = map (name: gpuCollectors.${name}.package) (
    lib.filter (name: gpuCollectors.${name} ? package) activeCollectors
  );

  gpuNeedsDevices = collectorAttrs "deviceAllow" != [ ];

  # capabilities granted under PrivateUsers are void on the host, see
  # systemd.exec(5), so these collectors also need the user namespace disabled
  gpuNeedsCapabilities = collectorAttrs "capabilities" != [ ];

  # Any explicit DeviceAllow turns DevicePolicy=auto into an allow-list, so the GPU
  # devices are omitted when smartmon relies on full /dev access.
  deviceAllowList =
    lib.optionals (cfg.smartmon.enable && cfg.smartmon.deviceAllow != [ ]) (
      map (device: "${device} r") cfg.smartmon.deviceAllow
    )
    ++ lib.optionals (!cfg.smartmon.enable || cfg.smartmon.deviceAllow != [ ]) (
      collectorAttrs "deviceAllow"
    );

  serviceCapabilities =
    lib.optionals cfg.smartmon.enable [
      "CAP_SYS_RAWIO"
      "CAP_SYS_ADMIN"
    ]
    ++ collectorAttrs "capabilities";
in
{
  meta.maintainers = with lib.maintainers; [
    BonusPlay
    arunoruto
  ];

  options.services.beszel.agent = {
    enable = lib.mkEnableOption "beszel agent";
    package = lib.mkPackageOption pkgs "beszel" { };
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/beszel-agent";
      description = "Data directory of beszel-agent.";
    };
    openFirewall = (lib.mkEnableOption "") // {
      description = "Whether to open the firewall port (default 45876).";
    };
    smartmon = {
      enable = lib.mkOption {
        default = false;
        example = true;
        description = "Include services.beszel.agent.smartmon.package in the Beszel agent path for disk monitoring and add the agent to the disk group.";
        type = lib.types.bool;
      };
      package = lib.mkPackageOption pkgs "smartmontools" { };
      deviceAllow = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "/dev/sda"
          "/dev/sdb"
          "/dev/nvme0"
        ];
        description = ''
          List of device paths to allow access to for SMART monitoring.
          This is only needed if the ambient capabilities are not sufficient.
          Devices will be granted read-only access.
        '';
      };
    };

    environment = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;
        options = {
          SKIP_SYSTEMD = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether to disable systemd service monitoring.
              Enabling this option will skip systemd tracking and its setup in NixOS.
            '';
          };
          SKIP_GPU = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether to disable GPU monitoring.
              Enabling this option will skip GPU tracking.
            '';
          };
          GPU_COLLECTOR = lib.mkOption {
            # upstream takes a comma-separated string, which used to be passed through as is
            type =
              with lib.types;
              coercedTo str (value: map lib.trim (lib.splitString "," value)) (
                listOf (enum (lib.attrNames gpuCollectors))
              );
            default =
              lib.optionals (hasVideoDriver "nvidia") [ "nvidia-smi" ]
              ++ lib.optionals (hasVideoDriver "amdgpu") [ "amd_sysfs" ]
              ++ lib.optionals (hasVideoDriver "intel") [ "intel_sysfs" ];
            defaultText = lib.literalMD ''
              derived from {option}`services.xserver.videoDrivers`
            '';
            example = [
              "nvidia-smi"
              "intel_gpu_top"
            ];
            description = ''
              GPU collectors to use, in priority order. Overrides the agent's
              auto-detection; the packages needed by the selected collectors are added
              to the service path. If empty, the agent auto-detects available
              collectors. `rocm-smi` is deprecated upstream in favour of `amd_sysfs`,
              and `intel_gpu_top` is not used on the xe driver, where `intel_sysfs` is
              preferred.

              Access to GPU device nodes is only granted for the collectors listed
              here, so a collector provided through
              {option}`services.beszel.agent.extraPath` has to be listed as well.
            '';
          };
        };
      };
      default = { };
      description = ''
        Environment variables for configuring the beszel-agent service.
        This field will end up public in /nix/store, for secret values (such as `KEY`) use `environmentFile`.

        See <https://www.beszel.dev/guide/environment-variables#agent> for available options.
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File path containing environment variables for configuring the beszel-agent service in the format of an EnvironmentFile. See {manpage}`systemd.exec(5)`.
      '';
    };
    extraPath = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Extra packages to add to beszel path (such as nvidia-smi or rocm-smi).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = lib.optionalString cfg.smartmon.enable ''
      # Change NVMe devices to disk group ownership for S.M.A.R.T. monitoring
      KERNEL=="nvme[0-9]*", GROUP="disk", MODE="0660"
    '';

    # Add D-Bus policy for systemd service monitoring following https://beszel.dev/guide/systemd#services-not-appearing
    services.dbus.packages = lib.optionals (!cfg.environment.SKIP_SYSTEMD) [
      (pkgs.writeTextDir "share/dbus-1/system.d/beszel-agent.conf" ''
        <?xml version="1.0" encoding="UTF-8"?> <!-- -*- XML -*- -->

        <!DOCTYPE busconfig PUBLIC
                  "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
                  "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">

        <busconfig>
          <policy user="beszel-agent">
            <allow
              send_destination="org.freedesktop.systemd1"
              send_type="method_call"
              send_path="/org/freedesktop/systemd1"
              send_interface="org.freedesktop.systemd1.Manager"
              send_member="ListUnits"
            />
          </policy>
        </busconfig>
      '')
    ];

    users.users.beszel-agent = lib.mkIf (!cfg.environment.SKIP_SYSTEMD) {
      isSystemUser = true;
      group = "beszel-agent";
    };

    users.groups.beszel-agent = lib.mkIf (!cfg.environment.SKIP_SYSTEMD) { };

    systemd.services.beszel-agent = {
      description = "Beszel Server Monitoring Agent";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      # drop empty lists so an unset GPU_COLLECTOR keeps upstream auto-detection
      environment = lib.mapAttrs (
        _: value:
        if lib.isBool value then
          (lib.boolToString value)
        else if lib.isList value then
          lib.concatStringsSep "," value
        else
          value
      ) (lib.filterAttrs (_: value: value != [ ]) (cfg.environment // { DATA_DIR = cfg.dataDir; }));

      path = cfg.extraPath ++ lib.optionals cfg.smartmon.enable [ cfg.smartmon.package ] ++ gpuPackages;

      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/beszel-agent
        '';

        EnvironmentFile = cfg.environmentFile;
        StateDirectory = baseNameOf cfg.dataDir;

        # adds ability to monitor docker/podman containers
        SupplementaryGroups =
          lib.optionals config.virtualisation.docker.enable [ "docker" ]
          ++ lib.optionals (
            config.virtualisation.podman.enable && config.virtualisation.podman.dockerSocket.enable
          ) [ "podman" ]
          ++ lib.optionals cfg.smartmon.enable [ "disk" ];

        DynamicUser = true;
        User = "beszel-agent";

        # Capabilities needed for SMART monitoring and GPU performance counters
        AmbientCapabilities = serviceCapabilities;
        CapabilityBoundingSet = serviceCapabilities;

        DeviceAllow = lib.mkIf (deviceAllowList != [ ]) deviceAllowList;

        LockPersonality = true;
        NoNewPrivileges = !cfg.smartmon.enable;
        PrivateDevices = !cfg.smartmon.enable && !gpuNeedsDevices;
        PrivateTmp = true;
        PrivateUsers = !cfg.smartmon.enable && !cfg.environment.SKIP_SYSTEMD && !gpuNeedsCapabilities;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = "read-only";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        Restart = "on-failure";
        RestartSec = "30s";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" ] ++ collectorAttrs "systemCalls";
        Type = "simple";
        UMask = 27;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      (
        if (builtins.hasAttr "PORT" cfg.environment) then
          (lib.strings.toInt cfg.environment.PORT)
        else
          45876
      )
    ];
  };
}

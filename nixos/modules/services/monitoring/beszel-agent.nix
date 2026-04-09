{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.beszel.agent;
in
{
  meta.maintainers = with lib.maintainers; [
    BonusPlay
    arunoruto
  ];

  options.services.beszel.agent = {
    enable = lib.mkEnableOption "beszel agent";
    package = lib.mkPackageOption pkgs "beszel" { };
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
            type =
              with lib.types;
              listOf (enum [
                "nvml"
                "nvidia-smi"
                "amd_sysfs"
                "rocm-smi"
                "intel_gpu_top"
                "nvtop"
              ]);
            default =
              let
                hasDriver = driver: builtins.elem driver config.services.xserver.videoDrivers;
              in
              lib.optionals (hasDriver "nvidia") [ "nvidia-smi" ]
              ++ lib.optionals (hasDriver "amdgpu") [ "rocm-smi" ]
              ++ lib.optionals (hasDriver "intel") [ "intel_gpu_top" ];
            defaultText = lib.literalExpression ''
              Automatically populated based on `config.services.xserver.videoDrivers`.
            '';
            example = [
              "nvidia-smi"
              "intel_gpu_top"
            ];
            description = ''
              List of collectors or a comma-separated string to use for GPU monitoring.
              If left unconfigured, it will attempt to detect the correct collector based on the system's video drivers.
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

      environment = lib.mapAttrs (
        _: value:
        if lib.isBool value then
          (lib.boolToString value)
        else if lib.isList value then
          lib.concatStringsSep "," value
        else
          value
      ) cfg.environment;

      path =
        cfg.extraPath
        ++ lib.optionals cfg.smartmon.enable [ cfg.smartmon.package ]
        ++ lib.optionals (!cfg.environment.SKIP_GPU) (
          let
            hasCollector = collector: builtins.elem collector cfg.environment.GPU_COLLECTOR;
          in
          lib.optionals (hasCollector "nvidia-smi") [ (lib.getBin config.hardware.nvidia.package) ]
          ++ lib.optionals (hasCollector "rocm-smi") [ (lib.getBin pkgs.rocmPackages.rocm-smi) ]
          ++ lib.optionals (hasCollector "intel_gpu_top") [ (lib.getBin pkgs.intel-gpu-tools) ]
          ++ lib.optionals (hasCollector "nvtop") [ (lib.getBin pkgs.nvtopPackages.full) ]
        );

      serviceConfig =
        let
          needsIntelPmu =
            !cfg.environment.SKIP_GPU && builtins.elem "intel_gpu_top" cfg.environment.GPU_COLLECTOR;
        in
        {
          ExecStart = ''
            ${cfg.package}/bin/beszel-agent
          '';

          EnvironmentFile = cfg.environmentFile;

          # adds ability to monitor docker/podman containers
          SupplementaryGroups =
            lib.optionals config.virtualisation.docker.enable [ "docker" ]
            ++ lib.optionals (
              config.virtualisation.podman.enable && config.virtualisation.podman.dockerSocket.enable
            ) [ "podman" ]
            ++ lib.optionals cfg.smartmon.enable [ "disk" ];

          DynamicUser = true;
          User = "beszel-agent";

          # Capabilities needed for
          #   SMART monitoring
          #   Intel (i)GPUs
          AmbientCapabilities =
            lib.optionals cfg.smartmon.enable [
              "CAP_SYS_RAWIO"
              "CAP_SYS_ADMIN"
            ]
            ++ lib.optionals needsIntelPmu [ "CAP_PERFMON" ];
          CapabilityBoundingSet =
            lib.optionals cfg.smartmon.enable [
              "CAP_SYS_RAWIO"
              "CAP_SYS_ADMIN"
            ]
            ++ lib.optionals needsIntelPmu [ "CAP_PERFMON" ];

          # Device access for SMART monitoring
          DeviceAllow = lib.mkIf (cfg.smartmon.enable && cfg.smartmon.deviceAllow != [ ]) (
            map (device: "${device} r") cfg.smartmon.deviceAllow
          );

          LockPersonality = true;
          NoNewPrivileges = !cfg.smartmon.enable;
          PrivateDevices = !cfg.smartmon.enable && cfg.environment.SKIP_GPU;
          PrivateUsers = !cfg.smartmon.enable && !cfg.environment.SKIP_SYSTEMD && cfg.environment.SKIP_GPU;
          PrivateTmp = true;
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
          SystemCallFilter = [ "@system-service" ] ++ lib.optionals needsIntelPmu [ "perf_event_open" ];
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

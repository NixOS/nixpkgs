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
      type = lib.types.attrsOf lib.types.str;
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

    systemd.services.beszel-agent = {
      description = "Beszel Server Monitoring Agent";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = cfg.environment;
      path =
        cfg.extraPath
        ++ lib.optionals cfg.smartmon.enable [ cfg.smartmon.package ]
        ++ lib.optionals (builtins.elem "nvidia" config.services.xserver.videoDrivers) [
          (lib.getBin config.hardware.nvidia.package)
        ]
        ++ lib.optionals (builtins.elem "amdgpu" config.services.xserver.videoDrivers) [
          (lib.getBin pkgs.rocmPackages.rocm-smi)
        ]
        ++ lib.optionals (builtins.elem "intel" config.services.xserver.videoDrivers) [
          (lib.getBin pkgs.intel-gpu-tools)
        ];

      serviceConfig = {
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

        # Capabilities needed for SMART monitoring
        AmbientCapabilities = lib.mkIf cfg.smartmon.enable [
          "CAP_SYS_RAWIO"
          "CAP_SYS_ADMIN"
        ];
        CapabilityBoundingSet = lib.mkIf cfg.smartmon.enable [
          "CAP_SYS_RAWIO"
          "CAP_SYS_ADMIN"
        ];

        # Device access for SMART monitoring
        DeviceAllow = lib.mkIf (cfg.smartmon.enable && cfg.smartmon.deviceAllow != [ ]) (
          map (device: "${device} r") cfg.smartmon.deviceAllow
        );

        LockPersonality = true;
        NoNewPrivileges = !cfg.smartmon.enable;
        PrivateDevices = !cfg.smartmon.enable;
        PrivateTmp = true;
        PrivateUsers = !cfg.smartmon.enable;
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
        SystemCallFilter = [ "@system-service" ];
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

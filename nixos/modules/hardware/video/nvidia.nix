# This module provides the proprietary NVIDIA X11 / OpenGL drivers.

{ config, lib, pkgs, ... }:

with lib;

let
  nvidia_x11 = let
    drivers = config.services.xserver.videoDrivers;
    isDeprecated = str: (hasPrefix "nvidia" str) && (str != "nvidia");
    hasDeprecated = drivers: any isDeprecated drivers;
  in if (hasDeprecated drivers) then
    throw ''
      Selecting an nvidia driver has been modified for NixOS 19.03. The version is now set using `hardware.nvidia.package`.
    ''
  else if (elem "nvidia" drivers) then cfg.package else null;

  enabled = nvidia_x11 != null;
  cfg = config.hardware.nvidia;

  pCfg = cfg.prime;
  syncCfg = pCfg.sync;
  offloadCfg = pCfg.offload;
  primeEnabled = syncCfg.enable || offloadCfg.enable;
  nvidiaPersistencedEnabled =  cfg.nvidiaPersistenced;
  nvidiaSettings = cfg.nvidiaSettings;
  busIDType = types.strMatching "([[:print:]]+[\:\@][0-9]{1,3}\:[0-9]{1,2}\:[0-9])?";
in

{
  imports =
    [
      (mkRenamedOptionModule [ "hardware" "nvidia" "optimus_prime" "enable" ] [ "hardware" "nvidia" "prime" "sync" "enable" ])
      (mkRenamedOptionModule [ "hardware" "nvidia" "optimus_prime" "allowExternalGpu" ] [ "hardware" "nvidia" "prime" "sync" "allowExternalGpu" ])
      (mkRenamedOptionModule [ "hardware" "nvidia" "optimus_prime" "nvidiaBusId" ] [ "hardware" "nvidia" "prime" "nvidiaBusId" ])
      (mkRenamedOptionModule [ "hardware" "nvidia" "optimus_prime" "intelBusId" ] [ "hardware" "nvidia" "prime" "intelBusId" ])
    ];

  options = {
    hardware.nvidia.powerManagement.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Experimental power management through systemd. For more information, see
        the NVIDIA docs, on Chapter 21. Configuring Power Management Support.
      '';
    };

    hardware.nvidia.powerManagement.finegrained = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Experimental power management of PRIME offload. For more information, see
        the NVIDIA docs, chapter 22. PCI-Express runtime power management.
      '';
    };

    hardware.nvidia.modesetting.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable kernel modesetting when using the NVIDIA proprietary driver.

        Enabling this fixes screen tearing when using Optimus via PRIME (see
        {option}`hardware.nvidia.prime.sync.enable`. This is not enabled
        by default because it is not officially supported by NVIDIA and would not
        work with SLI.
      '';
    };

    hardware.nvidia.prime.nvidiaBusId = mkOption {
      type = busIDType;
      default = "";
      example = "PCI:1:0:0";
      description = lib.mdDoc ''
        Bus ID of the NVIDIA GPU. You can find it using lspci; for example if lspci
        shows the NVIDIA GPU at "01:00.0", set this option to "PCI:1:0:0".
      '';
    };

    hardware.nvidia.prime.intelBusId = mkOption {
      type = busIDType;
      default = "";
      example = "PCI:0:2:0";
      description = lib.mdDoc ''
        Bus ID of the Intel GPU. You can find it using lspci; for example if lspci
        shows the Intel GPU at "00:02.0", set this option to "PCI:0:2:0".
      '';
    };

    hardware.nvidia.prime.amdgpuBusId = mkOption {
      type = busIDType;
      default = "";
      example = "PCI:4:0:0";
      description = lib.mdDoc ''
        Bus ID of the AMD APU. You can find it using lspci; for example if lspci
        shows the AMD APU at "04:00.0", set this option to "PCI:4:0:0".
      '';
    };

    hardware.nvidia.prime.sync.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable NVIDIA Optimus support using the NVIDIA proprietary driver via PRIME.
        If enabled, the NVIDIA GPU will be always on and used for all rendering,
        while enabling output to displays attached only to the integrated Intel GPU
        without a multiplexer.

        Note that this option only has any effect if the "nvidia" driver is specified
        in {option}`services.xserver.videoDrivers`, and it should preferably
        be the only driver there.

        If this is enabled, then the bus IDs of the NVIDIA and Intel GPUs have to be
        specified ({option}`hardware.nvidia.prime.nvidiaBusId` and
        {option}`hardware.nvidia.prime.intelBusId`).

        If you enable this, you may want to also enable kernel modesetting for the
        NVIDIA driver ({option}`hardware.nvidia.modesetting.enable`) in order
        to prevent tearing.

        Note that this configuration will only be successful when a display manager
        for which the {option}`services.xserver.displayManager.setupCommands`
        option is supported is used.
      '';
    };

    hardware.nvidia.prime.sync.allowExternalGpu = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Configure X to allow external NVIDIA GPUs when using optimus.
      '';
    };

    hardware.nvidia.prime.offload.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable render offload support using the NVIDIA proprietary driver via PRIME.

        If this is enabled, then the bus IDs of the NVIDIA and Intel GPUs have to be
        specified ({option}`hardware.nvidia.prime.nvidiaBusId` and
        {option}`hardware.nvidia.prime.intelBusId`).
      '';
    };

    hardware.nvidia.nvidiaSettings = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc ''
        Whether to add nvidia-settings, NVIDIA's GUI configuration tool, to
        systemPackages.
      '';
    };

    hardware.nvidia.nvidiaPersistenced = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Update for NVIDA GPU headless mode, i.e. nvidia-persistenced. It ensures all
        GPUs stay awake even during headless mode.
      '';
    };

    hardware.nvidia.forceFullCompositionPipeline = lib.mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Whether to force-enable the full composition pipeline.
        This sometimes fixes screen tearing issues.
        This has been reported to reduce the performance of some OpenGL applications and may produce issues in WebGL.
        It also drastically increases the time the driver needs to clock down after load.
      '';
    };

    hardware.nvidia.package = lib.mkOption {
      type = types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      defaultText = literalExpression "config.boot.kernelPackages.nvidiaPackages.stable";
      description = lib.mdDoc ''
        The NVIDIA X11 derivation to use.
      '';
      example = literalExpression "config.boot.kernelPackages.nvidiaPackages.legacy_340";
    };

    hardware.nvidia.open = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to use the open source kernel module
      '';
    };
  };

  config = let
      igpuDriver = if pCfg.intelBusId != "" then "modesetting" else "amdgpu";
      igpuBusId = if pCfg.intelBusId != "" then pCfg.intelBusId else pCfg.amdgpuBusId;
  in mkIf enabled {
    assertions = [
      {
        assertion = primeEnabled -> pCfg.intelBusId == "" || pCfg.amdgpuBusId == "";
        message = ''
          You cannot configure both an Intel iGPU and an AMD APU. Pick the one corresponding to your processor.
        '';
      }

      {
        assertion = primeEnabled -> pCfg.nvidiaBusId != "" && (pCfg.intelBusId != "" || pCfg.amdgpuBusId != "");
        message = ''
          When NVIDIA PRIME is enabled, the GPU bus IDs must configured.
        '';
      }

      {
        assertion = offloadCfg.enable -> versionAtLeast nvidia_x11.version "435.21";
        message = "NVIDIA PRIME render offload is currently only supported on versions >= 435.21.";
      }

      {
        assertion = !(syncCfg.enable && offloadCfg.enable);
        message = "Only one NVIDIA PRIME solution may be used at a time.";
      }

      {
        assertion = !(syncCfg.enable && cfg.powerManagement.finegrained);
        message = "Sync precludes powering down the NVIDIA GPU.";
      }

      {
        assertion = cfg.powerManagement.finegrained -> offloadCfg.enable;
        message = "Fine-grained power management requires offload to be enabled.";
      }

      {
        assertion = cfg.powerManagement.enable -> (
          builtins.pathExists (cfg.package.out + "/bin/nvidia-sleep.sh") &&
          builtins.pathExists (cfg.package.out + "/lib/systemd/system-sleep/nvidia")
        );
        message = "Required files for driver based power management don't exist.";
      }

      {
        assertion = cfg.open -> (cfg.package ? open && cfg.package ? firmware);
        message = "This version of NVIDIA driver does not provide a corresponding opensource kernel driver";
      }
    ];

    # If Optimus/PRIME is enabled, we:
    # - Specify the configured NVIDIA GPU bus ID in the Device section for the
    #   "nvidia" driver.
    # - Add the AllowEmptyInitialConfiguration option to the Screen section for the
    #   "nvidia" driver, in order to allow the X server to start without any outputs.
    # - Add a separate Device section for the Intel GPU, using the "modesetting"
    #   driver and with the configured BusID.
    # - OR add a separate Device section for the AMD APU, using the "amdgpu"
    #   driver and with the configures BusID.
    # - Reference that Device section from the ServerLayout section as an inactive
    #   device.
    # - Configure the display manager to run specific `xrandr` commands which will
    #   configure/enable displays connected to the Intel iGPU / AMD APU.

    services.xserver.useGlamor = mkDefault offloadCfg.enable;

    services.xserver.drivers = let
    in optional primeEnabled {
      name = igpuDriver;
      display = offloadCfg.enable;
      modules = optional (igpuDriver == "amdgpu") [ pkgs.xorg.xf86videoamdgpu ];
      deviceSection = ''
        BusID "${igpuBusId}"
        ${optionalString (syncCfg.enable && igpuDriver != "amdgpu") ''Option "AccelMethod" "none"''}
      '';
    } ++ singleton {
      name = "nvidia";
      modules = [ nvidia_x11.bin ];
      display = !offloadCfg.enable;
      deviceSection = optionalString primeEnabled
        ''
          BusID "${pCfg.nvidiaBusId}"
          ${optionalString syncCfg.allowExternalGpu "Option \"AllowExternalGpus\""}
        '';
      screenSection =
        ''
          Option "RandRRotation" "on"
        '' + optionalString syncCfg.enable ''
          Option "AllowEmptyInitialConfiguration"
        '' + optionalString cfg.forceFullCompositionPipeline ''
          Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
          Option         "AllowIndirectGLXProtocol" "off"
          Option         "TripleBuffer" "on"
        ''
        ;
    };

    services.xserver.serverLayoutSection = optionalString syncCfg.enable ''
      Inactive "Device-${igpuDriver}[0]"
    '' + optionalString offloadCfg.enable ''
      Option "AllowNVIDIAGPUScreens"
    '';

    services.xserver.displayManager.setupCommands = let
      sinkGpuProviderName = if igpuDriver == "amdgpu" then
        # find the name of the provider if amdgpu
        "`${pkgs.xorg.xrandr}/bin/xrandr --listproviders | ${pkgs.gnugrep}/bin/grep -i AMD | ${pkgs.gnused}/bin/sed -n 's/^.*name://p'`"
      else
        igpuDriver;
    in optionalString syncCfg.enable ''
      # Added by nvidia configuration module for Optimus/PRIME.
      ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource "${sinkGpuProviderName}" NVIDIA-0
      ${pkgs.xorg.xrandr}/bin/xrandr --auto
    '';

    environment.etc."nvidia/nvidia-application-profiles-rc" = mkIf nvidia_x11.useProfiles {
      source = "${nvidia_x11.bin}/share/nvidia/nvidia-application-profiles-rc";
    };

    # 'nvidia_x11' installs it's files to /run/opengl-driver/...
    environment.etc."egl/egl_external_platform.d".source =
      "/run/opengl-driver/share/egl/egl_external_platform.d/";

    hardware.opengl.extraPackages = [
      nvidia_x11.out
      pkgs.nvidia-vaapi-driver
    ];
    hardware.opengl.extraPackages32 = [
      nvidia_x11.lib32
      pkgs.pkgsi686Linux.nvidia-vaapi-driver
    ];

    environment.systemPackages = [ nvidia_x11.bin ]
      ++ optionals cfg.nvidiaSettings [ nvidia_x11.settings ]
      ++ optionals nvidiaPersistencedEnabled [ nvidia_x11.persistenced ];

    systemd.packages = optional cfg.powerManagement.enable nvidia_x11.out;

    systemd.services = let
      baseNvidiaService = state: {
        description = "NVIDIA system ${state} actions";

        path = with pkgs; [ kbd ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${nvidia_x11.out}/bin/nvidia-sleep.sh '${state}'";
        };
      };

      nvidiaService = sleepState: (baseNvidiaService sleepState) // {
        before = [ "systemd-${sleepState}.service" ];
        requiredBy = [ "systemd-${sleepState}.service" ];
      };

      services = (builtins.listToAttrs (map (t: nameValuePair "nvidia-${t}" (nvidiaService t)) ["hibernate" "suspend"]))
        // {
          nvidia-resume = (baseNvidiaService "resume") // {
            after = [ "systemd-suspend.service" "systemd-hibernate.service" ];
            requiredBy = [ "systemd-suspend.service" "systemd-hibernate.service" ];
          };
        };
    in optionalAttrs cfg.powerManagement.enable services
      // optionalAttrs nvidiaPersistencedEnabled {
        "nvidia-persistenced" = mkIf nvidiaPersistencedEnabled {
          description = "NVIDIA Persistence Daemon";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "forking";
            Restart = "always";
            PIDFile = "/var/run/nvidia-persistenced/nvidia-persistenced.pid";
            ExecStart = "${nvidia_x11.persistenced}/bin/nvidia-persistenced --verbose";
            ExecStopPost = "${pkgs.coreutils}/bin/rm -rf /var/run/nvidia-persistenced";
          };
        };
      };

    systemd.tmpfiles.rules = optional config.virtualisation.docker.enableNvidia
        "L+ /run/nvidia-docker/bin - - - - ${nvidia_x11.bin}/origBin"
      ++ optional (nvidia_x11.persistenced != null && config.virtualisation.docker.enableNvidia)
        "L+ /run/nvidia-docker/extras/bin/nvidia-persistenced - - - - ${nvidia_x11.persistenced}/origBin/nvidia-persistenced";

    boot.extraModulePackages = if cfg.open then [ nvidia_x11.open ] else [ nvidia_x11.bin ];
    hardware.firmware = lib.optional cfg.open nvidia_x11.firmware;

    # nvidia-uvm is required by CUDA applications.
    boot.kernelModules = [ "nvidia-uvm" ] ++
      optionals config.services.xserver.enable [ "nvidia" "nvidia_modeset" "nvidia_drm" ];

    # If requested enable modesetting via kernel parameter.
    boot.kernelParams = optional (offloadCfg.enable || cfg.modesetting.enable) "nvidia-drm.modeset=1"
      ++ optional cfg.powerManagement.enable "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      ++ optional cfg.open "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1";

    services.udev.extraRules =
      ''
        # Create /dev/nvidia-uvm when the nvidia-uvm module is loaded.
        KERNEL=="nvidia", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidiactl c $$(grep nvidia-frontend /proc/devices | cut -d \  -f 1) 255'"
        KERNEL=="nvidia", RUN+="${pkgs.runtimeShell} -c 'for i in $$(cat /proc/driver/nvidia/gpus/*/information | grep Minor | cut -d \  -f 4); do mknod -m 666 /dev/nvidia$${i} c $$(grep nvidia-frontend /proc/devices | cut -d \  -f 1) $${i}; done'"
        KERNEL=="nvidia_modeset", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-modeset c $$(grep nvidia-frontend /proc/devices | cut -d \  -f 1) 254'"
        KERNEL=="nvidia_uvm", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-uvm c $$(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 0'"
        KERNEL=="nvidia_uvm", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-uvm-tools c $$(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 1'"
      '' + optionalString cfg.powerManagement.finegrained (
      optionalString (versionOlder config.boot.kernelPackages.kernel.version "5.5") ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{remove}="1"

        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{remove}="1"

        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}="1"
      '' + ''
        # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
        ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
        ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"

        # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
        ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
        ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
      '');

    boot.extraModprobeConfig = mkIf cfg.powerManagement.finegrained ''
      options nvidia "NVreg_DynamicPowerManagement=0x02"
    '';

    boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

    services.acpid.enable = true;

  };

}

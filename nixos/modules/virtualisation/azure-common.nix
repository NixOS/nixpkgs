{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.virtualisation.azure;
  mlxDrivers = [
    "mlx4_en"
    "mlx4_core"
    "mlx5_core"
  ];
in
{
  options.virtualisation.azure = {
    acceleratedNetworking = mkOption {
      default = false;
      description = "Whether the machine's network interface has enabled accelerated networking.";
    };
  };

  imports = [
    ../profiles/headless.nix
    ./azure-agent.nix
  ];

  config = {
    virtualisation.azure.agent.enable = true;

    boot.kernelParams = [
      "console=ttyS0"
      "earlyprintk=ttyS0"
      "rootdelay=300"
      "panic=1"
      "boot.panic_on_fail"
    ];
    boot.initrd.kernelModules = [
      "hv_vmbus"
      "hv_netvsc"
      "hv_utils"
      "hv_storvsc"
    ];
    boot.initrd.availableKernelModules = lib.optionals cfg.acceleratedNetworking mlxDrivers;

    # Accelerated networking
    systemd.network.networks."99-azure-unmanaged-devices.network" = lib.mkIf cfg.acceleratedNetworking {
      matchConfig.Driver = mlxDrivers;
      linkConfig.Unmanaged = "yes";
    };
    networking.networkmanager.unmanaged = lib.mkIf cfg.acceleratedNetworking (
      builtins.map (drv: "driver:${drv}") mlxDrivers
    );

    # Generate a GRUB menu.
    boot.loader.grub.device = "/dev/sda";

    boot.growPartition = true;

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    # Allow root logins only using the SSH key that the user specified
    # at instance creation time, ping client connections to avoid timeouts
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "prohibit-password";
    services.openssh.settings.ClientAliveInterval = 180;

    # Force getting the hostname from Azure
    networking.hostName = mkDefault "";

    # Always include cryptsetup so that NixOps can use it.
    # sg_scan is needed to finalize disk removal on older kernels
    environment.systemPackages = [
      pkgs.cryptsetup
      pkgs.sg3_utils
    ];

    networking.usePredictableInterfaceNames = false;

    services.udev.extraRules = ''
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:0", ATTR{removable}=="0", SYMLINK+="disk/by-lun/0",
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:1", ATTR{removable}=="0", SYMLINK+="disk/by-lun/1",
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:2", ATTR{removable}=="0", SYMLINK+="disk/by-lun/2"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:3", ATTR{removable}=="0", SYMLINK+="disk/by-lun/3"

      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:4", ATTR{removable}=="0", SYMLINK+="disk/by-lun/4"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:5", ATTR{removable}=="0", SYMLINK+="disk/by-lun/5"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:6", ATTR{removable}=="0", SYMLINK+="disk/by-lun/6"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:7", ATTR{removable}=="0", SYMLINK+="disk/by-lun/7"

      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:8", ATTR{removable}=="0", SYMLINK+="disk/by-lun/8"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:9", ATTR{removable}=="0", SYMLINK+="disk/by-lun/9"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:10", ATTR{removable}=="0", SYMLINK+="disk/by-lun/10"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:11", ATTR{removable}=="0", SYMLINK+="disk/by-lun/11"

      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:12", ATTR{removable}=="0", SYMLINK+="disk/by-lun/12"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:13", ATTR{removable}=="0", SYMLINK+="disk/by-lun/13"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:14", ATTR{removable}=="0", SYMLINK+="disk/by-lun/14"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:15", ATTR{removable}=="0", SYMLINK+="disk/by-lun/15"

    '';
  };
}

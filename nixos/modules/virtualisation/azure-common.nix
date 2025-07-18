{
  config,
  lib,
  pkgs,
  ...
}:

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
    acceleratedNetworking = lib.mkOption {
      default = false;
      description = "Whether the machine's network interface has enabled accelerated networking.";
    };
  };

  config = {
    services.waagent.enable = true;

    # Enable cloud-init by default for waagent.
    # Otherwise waagent would try manage networking using ifupdown,
    # which is currently not available in nixpkgs.
    services.cloud-init.enable = true;
    services.cloud-init.network.enable = true;
    systemd.services.cloud-config.serviceConfig.Restart = "on-failure";

    # cloud-init.network.enable also enables systemd-networkd
    networking.useNetworkd = true;

    # Ensure kernel outputs to ttyS0 (Azure Serial Console),
    # and reboot machine upon fatal boot issues
    boot.kernelParams = [
      "console=ttyS0"
      "earlyprintk=ttyS0"
      "rootdelay=300"
      "panic=1"
      "boot.panic_on_fail"
    ];

    # Load Hyper-V kernel modules
    boot.initrd.kernelModules = [
      "hv_vmbus"
      "hv_netvsc"
      "hv_utils"
      "hv_storvsc"
    ];

    # Accelerated networking, configured following:
    # https://learn.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview
    boot.initrd.availableKernelModules = lib.optionals cfg.acceleratedNetworking mlxDrivers;
    systemd.network.networks."99-azure-unmanaged-devices.network" = lib.mkIf cfg.acceleratedNetworking {
      matchConfig.Driver = mlxDrivers;
      linkConfig.Unmanaged = "yes";
    };
    networking.networkmanager.unmanaged = lib.mkIf cfg.acceleratedNetworking (
      builtins.map (drv: "driver:${drv}") mlxDrivers
    );

    # Allow root logins only using the SSH key that the user specified
    # at instance creation time, ping client connections to avoid timeouts
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "prohibit-password";
    services.openssh.settings.ClientAliveInterval = 180;

    # Force getting the hostname from Azure
    networking.hostName = lib.mkDefault "";

    # Always include cryptsetup so that NixOps can use it.
    # sg_scan is needed to finalize disk removal on older kernels
    environment.systemPackages = [
      pkgs.cryptsetup
      pkgs.sg3_utils
    ];

    networking.usePredictableInterfaceNames = false;

    services.udev.extraRules = lib.concatMapStrings (i: ''
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:${toString i}", ATTR{removable}=="0", SYMLINK+="disk/by-lun/${toString i}"
    '') (lib.range 1 15);
  };
}

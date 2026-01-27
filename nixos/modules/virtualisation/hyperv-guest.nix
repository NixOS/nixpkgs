{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.virtualisation.hypervGuest;

in
{
  imports = [
    (mkRemovedOptionModule [
      "virtualisation"
      "hypervGuest"
      "videoMode"
    ] "The video mode can now be configured via standard tools, or in Hyper-V VM settings.")
  ];

  options = {
    virtualisation.hypervGuest = {
      enable = mkEnableOption "Hyper-V Guest Support";
    };
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.kernelModules = [
        "hv_balloon"
        "hv_netvsc"
        "hv_storvsc"
        "hv_utils"
        "hv_vmbus"
      ];

      initrd.availableKernelModules = [ "hyperv_keyboard" ];
    };

    environment.systemPackages = [ config.boot.kernelPackages.hyperv-daemons.bin ];

    services.udev.packages = [
      # enable hotadding cpu/memory
      (pkgs.writeTextFile {
        name = "hyperv-cpu-and-memory-hotadd-udev-rules";
        destination = "/etc/udev/rules.d/99-hyperv-cpu-and-memory-hotadd.rules";
        text = ''
          # Memory hotadd
          SUBSYSTEM=="memory", ACTION=="add", DEVPATH=="/devices/system/memory/memory[0-9]*", TEST=="state", ATTR{state}=="offline", ATTR{state}="online"

          # CPU hotadd
          SUBSYSTEM=="cpu", ACTION=="add", DEVPATH=="/devices/system/cpu/cpu[0-9]*", TEST=="online", ATTR{online}=="0", ATTR{online}="1"
        '';
      })

      # disable IO scheduler for virtual disks
      (pkgs.writeTextFile {
        name = "hyperv-disable-vdisk-scheduler-udev-rules";
        destination = "/etc/udev/rules.d/99-hyperv-disable-vdisk-scheduler.rules";
        text = ''
          SUBSYSTEM=="block", ACTION=="add|change", ENV{DEVTYPE}=="disk", KERNEL=="sd[a-z]*", ATTRS{vendor}=="Msft*", ATTRS{model}=="Virtual Disk*", ATTR{queue/scheduler}="none"
        '';
      })
    ];

    systemd = {
      packages = [ config.boot.kernelPackages.hyperv-daemons.lib ];

      targets.hyperv-daemons = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}

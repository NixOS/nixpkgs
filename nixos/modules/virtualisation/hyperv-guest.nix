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

      kernelParams = [
        "elevator=noop"
      ];
    };

    environment.systemPackages = [ config.boot.kernelPackages.hyperv-daemons.bin ];

    # enable hotadding cpu/memory
    services.udev.packages = lib.singleton (
      pkgs.writeTextFile {
        name = "hyperv-cpu-and-memory-hotadd-udev-rules";
        destination = "/etc/udev/rules.d/99-hyperv-cpu-and-memory-hotadd.rules";
        text = ''
          # Memory hotadd
          SUBSYSTEM=="memory", ACTION=="add", DEVPATH=="/devices/system/memory/memory[0-9]*", TEST=="state", ATTR{state}="online"

          # CPU hotadd
          SUBSYSTEM=="cpu", ACTION=="add", DEVPATH=="/devices/system/cpu/cpu[0-9]*", TEST=="online", ATTR{online}="1"
        '';
      }
    );

    systemd = {
      packages = [ config.boot.kernelPackages.hyperv-daemons.lib ];

      targets.hyperv-daemons = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}

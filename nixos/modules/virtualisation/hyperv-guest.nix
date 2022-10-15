{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.hypervGuest;

in {
  options = {
    virtualisation.hypervGuest = {
      enable = mkEnableOption (lib.mdDoc "Hyper-V Guest Support");

      videoMode = mkOption {
        type = types.str;
        default = "1152x864";
        example = "1024x768";
        description = lib.mdDoc ''
          Resolution at which to initialize the video adapter.

          Supports screen resolution up to Full HD 1920x1080 with 32 bit color
          on Windows Server 2012, and 1600x1200 with 16 bit color on Windows
          Server 2008 R2 or earlier.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.kernelModules = [
        "hv_balloon" "hv_netvsc" "hv_storvsc" "hv_utils" "hv_vmbus"
      ];

      initrd.availableKernelModules = [ "hyperv_keyboard" ];

      kernelParams = [
        "video=hyperv_fb:${cfg.videoMode}" "elevator=noop"
      ];
    };

    environment.systemPackages = [ config.boot.kernelPackages.hyperv-daemons.bin ];

    # enable hotadding cpu/memory
    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "hyperv-cpu-and-memory-hotadd-udev-rules";
      destination = "/etc/udev/rules.d/99-hyperv-cpu-and-memory-hotadd.rules";
      text = ''
        # Memory hotadd
        SUBSYSTEM=="memory", ACTION=="add", DEVPATH=="/devices/system/memory/memory[0-9]*", TEST=="state", ATTR{state}="online"

        # CPU hotadd
        SUBSYSTEM=="cpu", ACTION=="add", DEVPATH=="/devices/system/cpu/cpu[0-9]*", TEST=="online", ATTR{online}="1"
      '';
    });

    systemd = {
      packages = [ config.boot.kernelPackages.hyperv-daemons.lib ];

      services.hv-vss.unitConfig.ConditionPathExists = [ "/dev/vmbus/hv_vss" ];

      targets.hyperv-daemons = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}

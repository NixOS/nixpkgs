{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.hypervGuest;

in {
  options = {
    virtualisation.hypervGuest = {
      enable = mkEnableOption "Hyper-V Guest Support";

      videoMode = mkOption {
        type = types.str;
        default = "1152x864";
        example = "1024x768";
        description = ''
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

      kernelParams = [
        "video=hyperv_fb:${cfg.videoMode}"
      ];
    };

    environment.systemPackages = [ config.boot.kernelPackages.hyperv-daemons.bin ];

    security.rngd.enable = false;

    # enable hotadding memory
    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "hyperv-memory-hotadd-udev-rules";
      destination = "/etc/udev/rules.d/99-hyperv-memory-hotadd.rules";
      text = ''
        ACTION="add", SUBSYSTEM=="memory", ATTR{state}="online"
      '';
    });

    systemd = {
      packages = [ config.boot.kernelPackages.hyperv-daemons.lib ];

      targets.hyperv-daemons = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}

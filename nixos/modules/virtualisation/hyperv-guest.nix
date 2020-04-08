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

      enchanchedSessionMode = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable enchanched session mode.";
      };

      x11 = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable x11 graphics.";
      };
    };
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.kernelModules = [
        "hv_balloon" "hv_netvsc" "hv_storvsc" "hv_utils" "hv_vmbus"
      ];

      initrd.availableKernelModules = [
        "sd_mod" "sr_mod"
      ];

      kernelParams = [
        "video=hyperv_fb:${cfg.videoMode} elevator=noop"
      ];

      kernelModules = [
        "hv_sock"
      ];

      blacklistedKernelModules = [
        "vmw_vsock_vmci_transport"
      ];
    };

    environment.systemPackages = [ config.boot.kernelPackages.hyperv-daemons.bin ];

    security.rngd.enable = false;

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

    services.xserver = mkIf cfg.x11 {
      enable = mkDefault true;
      modules = [ pkgs.xorg.xf86videofbdev ];
      videoDrivers = mkOverride 50 [ "hyperv_fb" ];
    };

    services.xrdp = mkIf cfg.enchanchedSessionMode {
      enable = mkDefault true;
      port = mkDefault "vsock://-1:3389";
      globals = {
        security_layer = mkDefault "rdp";
        bitmap_compression = mkDefault false;
        bulk_compression = mkDefault false;
        new_cursor = mkDefault false;
      };
    };

    hardware.pulseaudio = {
      extraModules = mkIf cfg.enchanchedSessionMode [ pkgs.pulseaudio-module-xrdp ];
      extraConfig = ''
        load-module module-xrdp-sink
        load-module module-xrdp-source
      '';
    };

    systemd = {
      packages = [ config.boot.kernelPackages.hyperv-daemons.lib ];

      targets.hyperv-daemons = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}

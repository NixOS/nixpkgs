{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.vmware.guest;
  open-vm-tools = if cfg.headless then pkgs.open-vm-tools-headless else pkgs.open-vm-tools;
  xf86inputvmmouse = pkgs.xorg.xf86inputvmmouse;
in
{
  options.virtualisation.vmware.guest = {
    enable = mkEnableOption "VMWare Guest Support";
    headless = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to disable X11-related features.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64;
      message = "VMWare guest is not currently supported on ${pkgs.stdenv.hostPlatform.system}";
    } ];

    boot.initrd.kernelModules = [ "vmw_pvscsi" ];

    environment.systemPackages = [ open-vm-tools ];

    systemd.services.vmware =
      { description = "VMWare Guest Service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${open-vm-tools}/bin/vmtoolsd";
      };

    environment.etc."vmware-tools".source = "${open-vm-tools}/etc/vmware-tools/*";

    services.xserver = mkIf (!cfg.headless) {
      videoDrivers = mkOverride 50 [ "vmware" ];
      modules = [ xf86inputvmmouse ];

      config = ''
          Section "InputClass"
            Identifier "VMMouse"
            MatchDevicePath "/dev/input/event*"
            MatchProduct "ImPS/2 Generic Wheel Mouse"
            Driver "vmmouse"
          EndSection
        '';

      displayManager.sessionCommands = ''
          ${open-vm-tools}/bin/vmware-user-suid-wrapper
        '';
    };
  };
}

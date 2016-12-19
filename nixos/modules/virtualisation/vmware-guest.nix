{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vmwareGuest;
  open-vm-tools = pkgs.open-vm-tools;
  xf86inputvmmouse = pkgs.xorg.xf86inputvmmouse;
in
{
  options = {
    services.vmwareGuest.enable = mkEnableOption "VMWare Guest Support";
  };

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64;
      message = "VMWare guest is not currently supported on ${pkgs.stdenv.system}";
    } ];

    environment.systemPackages = [ open-vm-tools ];

    systemd.services.vmware =
      { description = "VMWare Guest Service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${open-vm-tools}/bin/vmtoolsd";
      };

    environment.etc."vmware-tools".source = "${pkgs.open-vm-tools}/etc/vmware-tools/*";

    services.xserver = {
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

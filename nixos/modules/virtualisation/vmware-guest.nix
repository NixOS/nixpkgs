{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vmwareGuest;
  open-vm-tools = pkgs.open-vm-tools;
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

      config = ''
          Section "InputDevice"
            Identifier "VMMouse"
            Driver "vmmouse"
          EndSection
        '';

      serverLayoutSection = ''
          InputDevice "VMMouse"
        '';

      displayManager.sessionCommands = ''
          ${open-vm-tools}/bin/vmware-user-suid-wrapper
        '';
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.cdemu;
in {

  options = {
    programs.cdemu = {
      enable = mkOption {
        default = false;
        description = "Whether to enable cdemu for users of appropriate group (default cdrom)";
      };
      group = mkOption {
        default = "cdrom";
        description = "Required group for users of cdemu";
      };
      gui = mkOption {
        default = true;
        description = "Whether to install cdemu GUI (gCDEmu)";
      };
      image-analyzer = mkOption {
        default = true;
        description = "Whether to install image analyzer";
      };
    };
  };

  config = mkIf cfg.enable {

    boot = {
      extraModulePackages = [ pkgs.linuxPackages.vhba ];
      kernelModules = [ "vhba" ];
    };

    services = {
      udev.extraRules = ''
        KERNEL=="vhba_ctl", MODE="0660", OWNER="root", GROUP="${cfg.group}"
      '';
      dbus.packages = [ pkgs.cdemu-daemon ];
    };

    environment.systemPackages =
      [ pkgs.cdemu-daemon pkgs.cdemu-client ]
      ++ optional cfg.gui pkgs.gcdemu
      ++ optional cfg.image-analyzer pkgs.image-analyzer;
  };

}

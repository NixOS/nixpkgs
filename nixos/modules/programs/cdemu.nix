{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.cdemu;
in {

  options = {
    programs.cdemu = {

      enable = mkWheneverToPkgOption {
        what = "globally configure cdemu";
        package = literalPackage pkgs "pkgs.cdemu-daemon";
      };

      group = mkOption {
        default = "cdrom";
        description = ''
          Group that users must be in to use <command>cdemu</command>.
        '';
      };
      gui = mkOption {
        default = true;
        description = ''
          Whether to install the <command>cdemu</command> GUI (gCDEmu).
        '';
      };
      image-analyzer = mkOption {
        default = true;
        description = ''
          Whether to install the image analyzer.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    boot = {
      extraModulePackages = [ config.boot.kernelPackages.vhba ];
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

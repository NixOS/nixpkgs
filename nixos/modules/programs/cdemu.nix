{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.cdemu;
in {

  options = {
    programs.cdemu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          <command>cdemu</command> for members of
          <option>programs.cdemu.group</option>.
        '';
      };
      group = mkOption {
        type = types.str;
        default = "cdrom";
        description = ''
          Group that users must be in to use <command>cdemu</command>.
        '';
      };
      gui = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install the <command>cdemu</command> GUI (gCDEmu).
        '';
      };
      image-analyzer = mkOption {
        type = types.bool;
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

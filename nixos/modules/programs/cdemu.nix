{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.cdemu;
in {

  options = {
    programs.cdemu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          {command}`cdemu` for members of
          {option}`programs.cdemu.group`.
        '';
      };
      group = mkOption {
        type = types.str;
        default = "cdrom";
        description = lib.mdDoc ''
          Group that users must be in to use {command}`cdemu`.
        '';
      };
      gui = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to install the {command}`cdemu` GUI (gCDEmu).
        '';
      };
      image-analyzer = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
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

    users.groups.${config.programs.cdemu.group} = {};

    # Systemd User service
    # manually adapted from example in source package:
    # https://sourceforge.net/p/cdemu/code/ci/master/tree/cdemu-daemon/service-example/cdemu-daemon.service
    systemd.user.services.cdemu-daemon.description = "CDEmu daemon";
    systemd.user.services.cdemu-daemon.serviceConfig = {
      Type = "dbus";
      BusName = "net.sf.cdemu.CDEmuDaemon";
      ExecStart = "${pkgs.cdemu-daemon}/bin/cdemu-daemon --config-file \"%h/.config/cdemu-daemon\"";
      Restart = "no";
    };

    environment.systemPackages =
      [ pkgs.cdemu-daemon pkgs.cdemu-client ]
      ++ optional cfg.gui pkgs.gcdemu
      ++ optional cfg.image-analyzer pkgs.image-analyzer;
  };

}

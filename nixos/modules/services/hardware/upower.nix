# Upower daemon.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.upower;

in

{

  ###### interface

  options = {

    services.upower = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Upower, a DBus service that provides power
          management support to applications.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.upower;
        defaultText = "pkgs.upower";
        example = lib.literalExample "pkgs.upower";
        description = ''
          Which upower package to use.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

  };

}

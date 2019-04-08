# Tumbler

{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.tumbler;
  tumbler = cfg.package;

in

{

  ###### interface

  options = {

    services.tumbler = {

      enable = mkEnableOption "Tumbler, A D-Bus thumbnailer service";

      package = mkOption {
        type = types.package;
        default = pkgs.xfce4-13.tumbler;
        description = "Which tumbler package to use";
        example = pkgs.xfce4-12.tumbler;
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [
      tumbler
    ];

    services.dbus.packages = [
      tumbler
    ];

  };

}

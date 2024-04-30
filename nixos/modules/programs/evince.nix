# Evince.

{ config, pkgs, lib, ... }:

with lib;

let cfg = config.programs.evince;

in {

  ###### interface

  options = {

    programs.evince = {

      enable = mkEnableOption "Evince, the GNOME document viewer";

      package = mkPackageOption pkgs "evince" { };

    };

  };


  ###### implementation

  config = mkIf config.programs.evince.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

  };

}

# File Roller.

{ config, pkgs, lib, ... }:

with lib;

let cfg = config.programs.file-roller;

in {

  ###### interface

  options = {

    programs.file-roller = {

      enable = mkEnableOption "File Roller, an archive manager for GNOME";

      package = mkPackageOption pkgs [ "gnome" "file-roller" ] { };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

  };

}

# File Roller.

{ config, pkgs, lib, ... }:

with lib;

{

  # Added 2019-08-09
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "file-roller" "enable" ]
      [ "programs" "file-roller" "enable" ])
  ];

  ###### interface

  options = {

    programs.file-roller = {

      enable = mkEnableOption "File Roller, an archive manager for GNOME";

    };

  };


  ###### implementation

  config = mkIf config.programs.file-roller.enable {

    environment.systemPackages = [ pkgs.gnome3.file-roller ];

    services.dbus.packages = [ pkgs.gnome3.file-roller ];

  };

}

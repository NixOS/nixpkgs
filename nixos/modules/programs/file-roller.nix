# File Roller.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.file-roller;

in
{

  ###### interface

  options = {

    programs.file-roller = {

      enable = lib.mkEnableOption "File Roller, an archive manager for GNOME";

      package = lib.mkPackageOption pkgs [ "gnome" "file-roller" ] { };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

  };

}

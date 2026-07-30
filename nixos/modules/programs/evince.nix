# Evince.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.evince;

in
{

  ###### interface

  options = {

    programs.evince = {

      enable = lib.mkEnableOption "Evince, the GNOME document viewer";

      package = lib.mkPackageOption pkgs "evince" { };

    };

  };

  ###### implementation

  config = lib.mkIf config.programs.evince.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

  };

}

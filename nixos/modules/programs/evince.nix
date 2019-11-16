# Evince.

{ config, pkgs, lib, ... }:

with lib;

{

  # Added 2019-08-09
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "evince" "enable" ]
      [ "programs" "evince" "enable" ])
  ];

  ###### interface

  options = {

    programs.evince = {

      enable = mkEnableOption
        "Evince, the GNOME document viewer";

    };

  };


  ###### implementation

  config = mkIf config.programs.evince.enable {

    environment.systemPackages = [ pkgs.evince ];

    services.dbus.packages = [ pkgs.evince ];

    systemd.packages = [ pkgs.evince ];

  };

}

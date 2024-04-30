# Seahorse.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    programs.seahorse = {

      enable = mkEnableOption "Seahorse, a GNOME application for managing encryption keys and passwords in the GNOME Keyring";

    };

  };


  ###### implementation

  config = mkIf config.programs.seahorse.enable {

    programs.ssh.askPassword = mkDefault "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

    environment.systemPackages = [
      pkgs.gnome.seahorse
    ];

    services.dbus.packages = [
      pkgs.gnome.seahorse
    ];

  };

}

# Seahorse.

{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    programs.seahorse = {

      enable = lib.mkEnableOption "Seahorse, a GNOME application for managing encryption keys and passwords in the GNOME Keyring";

    };

  };


  ###### implementation

  config = lib.mkIf config.programs.seahorse.enable {

    programs.ssh.askPassword = lib.mkDefault "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

    environment.systemPackages = [
      pkgs.gnome.seahorse
    ];

    services.dbus.packages = [
      pkgs.gnome.seahorse
    ];

  };

}

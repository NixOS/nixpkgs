# Seahorse.

{ config, pkgs, lib, ... }:

with lib;

{

 # Added 2019-08-27
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "seahorse" "enable" ]
      [ "programs" "seahorse" "enable" ])
  ];


  ###### interface

  options = {

    programs.seahorse = {

      enable = mkEnableOption "Seahorse, a GNOME application for managing encryption keys and passwords in the GNOME Keyring";

    };

  };


  ###### implementation

  config = mkIf config.programs.seahorse.enable {

    programs.ssh.askPassword = mkDefault "${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass";

    environment.systemPackages = [
      pkgs.gnome3.seahorse
    ];

    services.dbus.packages = [
      pkgs.gnome3.seahorse
    ];

  };

}

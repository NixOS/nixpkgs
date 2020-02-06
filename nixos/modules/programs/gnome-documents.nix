# GNOME Documents.

{ config, pkgs, lib, ... }:

with lib;

{

  # Added 2019-08-09
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-documents" "enable" ]
      [ "programs" "gnome-documents" "enable" ])
  ];

  ###### interface

  options = {

    programs.gnome-documents = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Documents, a document
          manager application for GNOME.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.programs.gnome-documents.enable {

    environment.systemPackages = [ pkgs.gnome3.gnome-documents ];

    services.dbus.packages = [ pkgs.gnome3.gnome-documents ];

    services.gnome3.gnome-online-accounts.enable = true;

    services.gnome3.gnome-online-miners.enable = true;

  };

}

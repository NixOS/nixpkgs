# GNOME Documents.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2019-08-09
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome" "gnome-documents" "enable" ]
      [ "programs" "gnome-documents" "enable" ])
  ];

  ###### interface

  options = {

    programs.gnome-documents = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable GNOME Documents, a document
          manager application for GNOME.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.programs.gnome-documents.enable {

    environment.systemPackages = [ pkgs.gnome.gnome-documents ];

    services.dbus.packages = [ pkgs.gnome.gnome-documents ];

    services.gnome.gnome-online-accounts.enable = true;

    services.gnome.gnome-online-miners.enable = true;

  };

}

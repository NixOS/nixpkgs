# File Roller.

{ config, pkgs, lib, ... }:

with lib;

let cfg = config.programs.file-roller;

in {

  # Added 2019-08-09
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "file-roller" "enable" ]
      [ "programs" "file-roller" "enable" ])
  ];

  ###### interface

  options = {

    programs.file-roller = {

      enable = mkEnableOption (lib.mdDoc "File Roller, an archive manager for GNOME");

      package = mkOption {
        type = types.package;
        default = pkgs.gnome.file-roller;
        defaultText = literalExpression "pkgs.gnome.file-roller";
        description = lib.mdDoc "File Roller derivation to use.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

  };

}

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.mailspring;

in

{
  options = {
    programs.mailspring = {

      enable = mkEnableOption ''
        mailspring - A beautiful, fast and maintained fork of Nylas Mail by one of the original authors
      '';

      gnome3-keyring = mkOption {
        type = types.bool;
        default = true;
        description = "Enable gnome3 keyring for mailspring.";
      };
    };
  };


  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mailspring ];

    services.gnome3.gnome-keyring = mkIf cfg.gnome3-keyring {
      enable = true;
    };
  };
}

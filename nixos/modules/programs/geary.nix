{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.geary;

in {
  options = {
    programs.geary.enable = mkEnableOption "Geary, a Mail client for GNOME 3";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome3.geary ];
    programs.dconf.enable = true;
    services.gnome3.gnome-keyring.enable = true;
    services.gnome3.gnome-online-accounts.enable = true;
  };
}


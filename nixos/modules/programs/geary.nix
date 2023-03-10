{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.geary;

in {
  meta = {
    maintainers = teams.gnome.members;
  };

  options = {
    programs.geary.enable = mkEnableOption (lib.mdDoc "Geary, a Mail client for GNOME 3");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome.geary ];
    programs.dconf.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.gnome.gnome-online-accounts.enable = true;
  };
}


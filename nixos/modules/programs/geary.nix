{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.geary;

in
{
  meta = {
    maintainers = lib.teams.gnome.members;
  };

  options = {
    programs.geary.enable = lib.mkEnableOption "Geary, a Mail client for GNOME";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.geary ];
    programs.dconf.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.gnome.gnome-online-accounts.enable = true;
  };
}

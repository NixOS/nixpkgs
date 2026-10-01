{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    teams
    ;
in

{
  meta = {
    teams = [ teams.gnome ];
  };

  options = {
    services.gnome.gnome-browser-connector.enable = mkEnableOption ''
      native host connector for the GNOME Shell browser extension, a DBus service
      allowing to install GNOME Shell extensions from a web browser
    '';
  };

  config = mkIf config.services.gnome.gnome-browser-connector.enable {
    environment.systemPackages = [ pkgs.gnome-browser-connector ];

    services.dbus.packages = [ pkgs.gnome-browser-connector ];

    programs.chromium.nativeMessagingHosts.packages = [ pkgs.gnome-browser-connector ];
    programs.firefox.nativeMessagingHosts.packages = [ pkgs.gnome-browser-connector ];
  };
}

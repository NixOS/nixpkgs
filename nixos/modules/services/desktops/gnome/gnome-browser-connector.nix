{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkRenamedOptionModule teams;
in

{
  meta = {
    maintainers = teams.gnome.members;
  };

  options = {
    services.gnome.gnome-browser-connector.enable = mkEnableOption ''
      native host connector for the GNOME Shell browser extension, a DBus service
      allowing to install GNOME Shell extensions from a web browser
    '';
  };

  config = mkIf config.services.gnome.gnome-browser-connector.enable {
    environment.etc = {
      "chromium/native-messaging-hosts/org.gnome.browser_connector.json".source = "${pkgs.gnome-browser-connector}/etc/chromium/native-messaging-hosts/org.gnome.browser_connector.json";
      "opt/chrome/native-messaging-hosts/org.gnome.browser_connector.json".source = "${pkgs.gnome-browser-connector}/etc/opt/chrome/native-messaging-hosts/org.gnome.browser_connector.json";
      # Legacy paths.
      "chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.gnome-browser-connector}/etc/chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
      "opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.gnome-browser-connector}/etc/opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
    };

    environment.systemPackages = [ pkgs.gnome-browser-connector ];

    services.dbus.packages = [ pkgs.gnome-browser-connector ];

    programs.firefox.nativeMessagingHosts.packages = [ pkgs.gnome-browser-connector ];
  };
}

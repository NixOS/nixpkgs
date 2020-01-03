# Chrome GNOME Shell native host connector.
{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface
  options = {
    services.gnome3.chrome-gnome-shell.enable = mkEnableOption ''
      Chrome GNOME Shell native host connector, a DBus service
      allowing to install GNOME Shell extensions from a web browser.
    '';
  };


  ###### implementation
  config = mkIf config.services.gnome3.chrome-gnome-shell.enable {
    environment.etc = {
      "chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.chrome-gnome-shell}/etc/chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
      "opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.chrome-gnome-shell}/etc/opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
    };

    environment.systemPackages = [ pkgs.chrome-gnome-shell ];

    services.dbus.packages = [ pkgs.chrome-gnome-shell ];

    nixpkgs.config.firefox.enableGnomeExtensions = true;
  };
}

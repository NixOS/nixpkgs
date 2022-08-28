# Chrome GNOME Shell native host connector.
{ config, lib, pkgs, ... }:

with lib;

{
  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "chrome-gnome-shell" "enable" ]
      [ "services" "gnome" "chrome-gnome-shell" "enable" ]
    )
  ];

  ###### interface
  options = {
    services.gnome.chrome-gnome-shell.enable = mkEnableOption (lib.mdDoc ''
      Chrome GNOME Shell native host connector, a DBus service
      allowing to install GNOME Shell extensions from a web browser.
    '');
  };


  ###### implementation
  config = mkIf config.services.gnome.chrome-gnome-shell.enable {
    environment.etc = {
      "chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.chrome-gnome-shell}/etc/chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
      "opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.chrome-gnome-shell}/etc/opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
    };

    environment.systemPackages = [ pkgs.chrome-gnome-shell ];

    services.dbus.packages = [ pkgs.chrome-gnome-shell ];

    nixpkgs.config.firefox.enableGnomeExtensions = true;
  };
}

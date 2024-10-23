{ lib, config, pkgs, ... }:

let
  cfg = config.programs.chrome-remote-desktop;
in
{
  options.programs.chrome-remote-desktop = {
    enable = lib.mkEnableOption "Chrome Remote Desktop";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc = {
        "chromium/native-messaging-hosts/com.google.chrome.remote_assistance.json".source = "${pkgs.chrome-remote-desktop}/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_assistance.json";
        "chromium/native-messaging-hosts/com.google.chrome.remote_desktop.json".source = "${pkgs.chrome-remote-desktop}/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_desktop.json";
      };
      systemPackages = [ pkgs.chrome-remote-desktop ];
    };

    security = {
      wrappers.crd-user-session = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.chrome-remote-desktop}/opt/google/chrome-remote-desktop/user-session";
      };

      pam.services.chrome-remote-desktop.text = ''
        auth        required    pam_unix.so
        account     required    pam_unix.so
        password    required    pam_unix.so
        session     required    pam_unix.so
      '';
    };

    users.groups.chrome-remote-desktop = { };

    systemd.packages = [
      pkgs.chrome-remote-desktop
    ];
  };
}

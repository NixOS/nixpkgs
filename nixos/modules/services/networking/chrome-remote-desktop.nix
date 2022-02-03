{ lib, config, options, pkgs, ... }:
with lib;
let
  cfg = config.services.chrome-remote-desktop;
  chrome-remote-desktop = pkgs.chrome-remote-desktop.override { enableNewSession = cfg.newSession; };
in {
  options.services.chrome-remote-desktop = {
    enable = mkEnableOption "Chrome Remote Desktop";
    user = mkOption {
      type = types.str;
      description = ''
        A user which the service will run as.
      '';
      example = "alice";
    };
    newSession = mkOption {
      type = types.bool;
      description = "Whether to start a new session";
      default = false;
      example = "true";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc = {
        "chromium/native-messaging-hosts/com.google.chrome.remote_assistance.json".source = "${chrome-remote-desktop}/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_assistance.json";
        "chromium/native-messaging-hosts/com.google.chrome.remote_desktop.json".source = "${chrome-remote-desktop}/etc/opt/chrome/native-messaging-hosts/com.google.chrome.remote_desktop.json";
      };
      systemPackages = [ chrome-remote-desktop ];
    };

    security = {
      wrappers.crd-user-session.source = "${chrome-remote-desktop}/opt/google/chrome-remote-desktop/user-session";
      wrappers.crd-user-session.owner = cfg.user;
      wrappers.crd-user-session.group = "chrome-remote-desktop";
      pam.services.chrome-remote-desktop.text = ''
        auth        required    pam_unix.so
        account     required    pam_unix.so
        password    required    pam_unix.so
        session     required    pam_unix.so
      '';
    };

    users.groups.chrome-remote-desktop = {};

    users.users.${cfg.user}.extraGroups = [ "chrome-remote-desktop" ];

    systemd.packages = [
      chrome-remote-desktop
    ];

    # Reference : ${pkgs.chrome-remote-desktop}/lib/systemd/system/chrome-remote-desktop@.service
    systemd.services."chrome-remote-desktop@${cfg.user}" = {
      enable = true;
      description = "Chrome Remote Desktop instance for ${cfg.user}";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Environment = "XDG_SESSION_CLASS=user XDG_SESSION_TYPE=x11";
        PAMName = "chrome-remote-desktop";
        TTYPath = "/dev/chrome-remote-desktop";
        ExecStart = "${chrome-remote-desktop}/opt/google/chrome-remote-desktop/chrome-remote-desktop --start --new-session";
        ExecReload = "${chrome-remote-desktop}/opt/google/chrome-remote-desktop/chrome-remote-desktop --reload";
        ExecStop = "${chrome-remote-desktop}/opt/google/chrome-remote-desktop/chrome-remote-desktop --stop";
        StandardOutput = "journal";
        StandardError = "inherit";
        RestartForceExitStatus = "41";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}

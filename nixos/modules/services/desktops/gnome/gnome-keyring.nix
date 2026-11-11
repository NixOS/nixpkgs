# GNOME Keyring daemon.

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.gnome.gnome-keyring;
in
{

  meta = {
    teams = [ lib.teams.gnome ];
  };

  options = {
    services.gnome.gnome-keyring = {
      enable = lib.mkEnableOption ''
        GNOME Keyring daemon, a service designed to
        take care of the user's security credentials,
        such as user names and passwords
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome-keyring ];

    services.dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr_3
    ];

    # pam_gnome_keyring unlocks the socket-activated daemon instead of starting
    # a `--login` daemon, which exits unless the session initializes it in time.
    systemd.packages = [ pkgs.gnome-keyring ];
    systemd.user.sockets.gnome-keyring-daemon = {
      wantedBy = [ "sockets.target" ];
      # A daemon that pam_gnome_keyring started before a switch owns the path and
      # unlinks it on exit.
      unitConfig.ConditionPathExists = "!%t/keyring/control";
      # Otherwise the leftover socket file trips the condition above on the next start.
      socketConfig.RemoveOnStop = true;
    };
    systemd.user.services.gnome-keyring-daemon = {
      # A restart replaces the unlocked daemon with one that never received the password.
      restartIfChanged = false;
      # Without the socket's file descriptor the daemon binds the path itself.
      unitConfig.BindsTo = [ "gnome-keyring-daemon.socket" ];
    };

    xdg.portal.extraPortals = [ pkgs.gnome-keyring ];

    security.pam.services.login.enableGnomeKeyring = true;

    security.wrappers.gnome-keyring-daemon = {
      owner = "root";
      group = "root";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon";
    };
  };
}

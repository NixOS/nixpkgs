# GNOME Keyring daemon.

{ config, pkgs, lib, ... }:
let
  cfg = config.services.gnome.gnome-keyring;
in
{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.gnome-keyring = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Keyring daemon, a service designed to
          take care of the user's security credentials,
          such as user names and passwords.
        '';
      };

      enableSSHSupport = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable SSH agent support in Gnome Keyring by setting SSH_AUTH_SOCK
          environment variable correctly.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.gnome.gnome-keyring ];

    services.dbus.packages = [ pkgs.gnome.gnome-keyring pkgs.gcr ];

    xdg.portal.extraPortals = [ pkgs.gnome.gnome-keyring ];

    security.pam.services.login.enableGnomeKeyring = true;

    security.wrappers.gnome-keyring-daemon = {
      owner = "root";
      group = "root";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon";
    };

    environment.extraInit = lib.mkIf cfg.enableSSHSupport ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
      fi
    '';

  };

}

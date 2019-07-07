# This module gets rid of all dependencies on X11 client libraries
# (including fontconfig).

{ config, lib, ... }:

with lib;

{
  options = {
    environment.noXlibs = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Switch off the options in the default configuration that
        require X11 libraries. This includes client-side font
        configuration and SSH forwarding of X11 authentication
        in. Thus, you probably do not want to enable this option if
        you want to run X11 programs on this machine via SSH.
      '';
    };
  };

  config = mkIf config.environment.noXlibs {
    programs.ssh.setXAuthLocation = false;
    security.pam.services.su.forwardXAuth = lib.mkForce false;

    fonts.fontconfig.enable = false;

    nixpkgs.overlays = singleton (const (super: {
      dbus = super.dbus.override { x11Support = false; };
      networkmanager-fortisslvpn = super.networkmanager-fortisslvpn.override { withGnome = false; };
      networkmanager-l2tp = super.networkmanager-l2tp.override { withGnome = false; };
      networkmanager-openconnect = super.networkmanager-openconnect.override { withGnome = false; };
      networkmanager-openvpn = super.networkmanager-openvpn.override { withGnome = false; };
      networkmanager-vpnc = super.networkmanager-vpnc.override { withGnome = false; };
      networkmanager-iodine = super.networkmanager-iodine.override { withGnome = false; };
      pinentry = super.pinentry.override { gtk2 = null; gcr = null; qt = null; };
      gobject-introspection = super.gobject-introspection.override { x11Support = false; };
    }));
  };
}

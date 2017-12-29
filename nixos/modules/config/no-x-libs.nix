# This module gets rid of all dependencies on X11 client libraries
# (including fontconfig).

{ config, lib, pkgs, ... }:

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

    nixpkgs.config.packageOverrides = pkgs: {
      dbus = pkgs.dbus.override { x11Support = false; };
      networkmanager_fortisslvpn = pkgs.networkmanager_fortisslvpn.override { withGnome = false; };
      networkmanager_l2tp = pkgs.networkmanager_l2tp.override { withGnome = false; };
      networkmanager_openconnect = pkgs.networkmanager_openconnect.override { withGnome = false; };
      networkmanager_openvpn = pkgs.networkmanager_openvpn.override { withGnome = false; };
      networkmanager_pptp = pkgs.networkmanager_pptp.override { withGnome = false; };
      networkmanager_vpnc = pkgs.networkmanager_vpnc.override { withGnome = false; };
      pinentry = pkgs.pinentry.override { gtk2 = null; qt4 = null; };
    };
  };
}

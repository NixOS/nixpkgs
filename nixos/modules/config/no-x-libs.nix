# This module gets rid of all dependencies on X11 client libraries
# (including fontconfig).

{ config, lib, ... }:

with lib;

{
  options = {
    environment.noXlibs = mkOption {
      type = types.bool;
      default = !config.services.xserver.enable && !config.services.xrdp.enable;
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
    security.pam.services.su.forwardXAuth = lib.mkDefault false;
    services.openssh.forwardX11 = lib.mkDefault false;
    
    services.udisks2.enable = lib.mkDefault false;
    security.polkit.enable = lib.mkDefault false;

    nixpkgs.overlays = singleton (const (super: {
      dbus = super.dbus.override { x11Support = false; };
      networkmanager-fortisslvpn = super.networkmanager-fortisslvpn.override { withGnome = false; };
      networkmanager-l2tp = super.networkmanager-l2tp.override { withGnome = false; };
      networkmanager-openconnect = super.networkmanager-openconnect.override { withGnome = false; };
      networkmanager-openvpn = super.networkmanager-openvpn.override { withGnome = false; };
      networkmanager-vpnc = super.networkmanager-vpnc.override { withGnome = false; };
      networkmanager-iodine = super.networkmanager-iodine.override { withGnome = false; };
      pinentry = super.pinentry_ncurses;
      gobjectIntrospection = super.gobjectIntrospection.override { x11Support = false; };
    }));
  };
}

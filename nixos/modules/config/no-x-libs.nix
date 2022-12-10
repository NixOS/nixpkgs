# This module gets rid of all dependencies on X11 client libraries
# (including fontconfig).

{ config, lib, ... }:

with lib;

{
  options = {
    environment.noXlibs = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
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
      beam = super.beam_nox;
      cairo = super.cairo.override { x11Support = false; };
      dbus = super.dbus.override { x11Support = false; };
      ffmpeg_4 = super.ffmpeg_4-headless;
      ffmpeg_5 = super.ffmpeg_5-headless;
      # dep of graphviz, libXpm is optional for Xpm support
      gd = super.gd.override { libXpm = null; };
      gobject-introspection = super.gobject-introspection.override { x11Support = false; };
      gpsd = super.gpsd.override { guiSupport = false; };
      graphviz = super.graphviz-nox;
      gst_all_1 = super.gst_all_1 // {
        gst-plugins-base = super.gst_all_1.gst-plugins-base.override { enableX11 = false; };
      };
      imagemagick = super.imagemagick.override { libX11Support = false; libXtSupport = false; };
      imagemagickBig = super.imagemagickBig.override { libX11Support = false; libXtSupport = false; };
      libdevil = super.libdevil-nox;
      libextractor = super.libextractor.override { gtkSupport = false; };
      libva = super.libva-minimal;
      limesuite = super.limesuite.override { withGui = false; };
      mpv-unwrapped = super.mpv-unwrapped.override { sdl2Support = false; x11Support = false; };
      msmtp = super.msmtp.override { withKeyring = false; };
      networkmanager-fortisslvpn = super.networkmanager-fortisslvpn.override { withGnome = false; };
      networkmanager-iodine = super.networkmanager-iodine.override { withGnome = false; };
      networkmanager-l2tp = super.networkmanager-l2tp.override { withGnome = false; };
      networkmanager-openconnect = super.networkmanager-openconnect.override { withGnome = false; };
      networkmanager-openvpn = super.networkmanager-openvpn.override { withGnome = false; };
      networkmanager-sstp = super.networkmanager-vpnc.override { withGnome = false; };
      networkmanager-vpnc = super.networkmanager-vpnc.override { withGnome = false; };
      pango = super.pango.override { x11Support = false; };
      pinentry = super.pinentry.override { enabledFlavors = [ "curses" "tty" "emacs" ]; withLibsecret = false; };
      qemu = super.qemu.override { gtkSupport = false; spiceSupport = false; sdlSupport = false; };
      qrencode = super.qrencode.overrideAttrs (_: { doCheck = false; });
      stoken = super.stoken.override { withGTK3 = false; };
      # translateManpages -> perlPackages.po4a -> texlive-combined-basic -> texlive-core-big -> libX11
      util-linux = super.util-linux.override { translateManpages = false; };
      zbar = super.zbar.override { enableVideo = false; withXorg = false; };
    }));
  };
}

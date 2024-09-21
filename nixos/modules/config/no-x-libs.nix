# This module gets rid of all dependencies on X11 client libraries
# (including fontconfig).
{ config, lib, ... }:
{
  options = {
    environment.noXlibs = lib.mkOption {
      type = lib.types.bool;
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

  config = lib.mkIf config.environment.noXlibs {
    programs.ssh.setXAuthLocation = false;
    security.pam.services.su.forwardXAuth = lib.mkForce false;

    fonts.fontconfig.enable = false;

    nixpkgs.overlays = lib.singleton (lib.const (super: {
      beam = super.beam_nox;
      cairo = super.cairo.override { x11Support = false; };
      dbus = super.dbus.override { x11Support = false; };
      fastfetch = super.fastfetch.override { vulkanSupport = false; waylandSupport = false; x11Support = false; };
      ffmpeg = super.ffmpeg.override { ffmpegVariant = "headless"; };
      ffmpeg_4 = super.ffmpeg_4.override { ffmpegVariant = "headless"; };
      ffmpeg_6 = super.ffmpeg_6.override { ffmpegVariant = "headless"; };
      ffmpeg_7 = super.ffmpeg_7.override { ffmpegVariant = "headless"; };
      # dep of graphviz, libXpm is optional for Xpm support
      gd = super.gd.override { withXorg = false; };
      ghostscript = super.ghostscript.override { cupsSupport = false; x11Support = false; };
      gjs = (super.gjs.override { installTests = false; }).overrideAttrs { doCheck = false; }; # avoid test dependency on gtk3
      gobject-introspection = super.gobject-introspection.override { x11Support = false; };
      gpg-tui = super.gpg-tui.override { x11Support = false; };
      gpsd = super.gpsd.override { guiSupport = false; };
      graphviz = super.graphviz-nox;
      gst_all_1 = super.gst_all_1 // {
        gst-plugins-bad = super.gst_all_1.gst-plugins-bad.override { guiSupport = false; };
        gst-plugins-base = super.gst_all_1.gst-plugins-base.override { enableGl = false; enableWayland = false; enableX11 = false; };
        gst-plugins-good = super.gst_all_1.gst-plugins-good.override { enableWayland = false; enableX11 = false; gtkSupport = false; qt5Support = false; qt6Support = false; };
        gst-plugins-rs = super.gst_all_1.gst-plugins-rs.override { withGtkPlugins = false; };
      };
      imagemagick = super.imagemagick.override { libX11Support = false; libXtSupport = false; };
      imagemagickBig = super.imagemagickBig.override { libX11Support = false; libXtSupport = false; };
      intel-vaapi-driver = super.intel-vaapi-driver.override { enableGui = false; };
      libdevil = super.libdevil-nox;
      libextractor = super.libextractor.override { gtkSupport = false; };
      libplacebo = super.libplacebo.override { vulkanSupport = false; };
      libva = super.libva-minimal;
      limesuite = super.limesuite.override { withGui = false; };
      mc = super.mc.override { x11Support = false; };
      mpv-unwrapped = super.mpv-unwrapped.override { drmSupport = false; screenSaverSupport = false; sdl2Support = false; vulkanSupport = false; waylandSupport = false; x11Support = false; };
      msmtp = super.msmtp.override { withKeyring = false; };
      mupdf = super.mupdf.override { enableGL = false; enableX11 = false; };
      neofetch = super.neofetch.override { x11Support = false; };
      networkmanager-fortisslvpn = super.networkmanager-fortisslvpn.override { withGnome = false; };
      networkmanager-iodine = super.networkmanager-iodine.override { withGnome = false; };
      networkmanager-l2tp = super.networkmanager-l2tp.override { withGnome = false; };
      networkmanager-openconnect = super.networkmanager-openconnect.override { withGnome = false; };
      networkmanager-openvpn = super.networkmanager-openvpn.override { withGnome = false; };
      networkmanager-sstp = super.networkmanager-vpnc.override { withGnome = false; };
      networkmanager-vpnc = super.networkmanager-vpnc.override { withGnome = false; };
      pango = super.pango.override { x11Support = false; };
      pinentry-curses = super.pinentry-curses.override { withLibsecret = false; };
      pinentry-tty = super.pinentry-tty.override { withLibsecret = false; };
      pipewire = super.pipewire.override { vulkanSupport = false; x11Support = false; };
      pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          # tk feature requires wayland which fails to compile
          matplotlib = python-prev.matplotlib.override { enableTk = false; };
        })
      ];
      qemu = super.qemu.override { gtkSupport = false; spiceSupport = false; sdlSupport = false; };
      qrencode = super.qrencode.overrideAttrs (_: { doCheck = false; });
      qt5 = super.qt5.overrideScope (lib.const (super': {
        qtbase = super'.qtbase.override { withGtk3 = false; withQttranslation = false; };
      }));
      stoken = super.stoken.override { withGTK3 = false; };
      # translateManpages -> perlPackages.po4a -> texlive-combined-basic -> texlive-core-big -> libX11
      util-linux = super.util-linux.override { translateManpages = false; };
      vim-full = super.vim-full.override { guiSupport = false; };
      vte = super.vte.override { gtkVersion = null; };
      zbar = super.zbar.override { enableVideo = false; withXorg = false; };
    }));
  };
}

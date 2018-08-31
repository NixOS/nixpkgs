{ stdenv, lib, fetchurl, dpkg, makeDesktopItem, gnome2, gtk2, atk, cairo, pango, gdk_pixbuf, glib
, freetype, fontconfig, dbus, libnotify, libX11, xorg, libXi, libXcursor, libXdamage
, libXrandr, libXcomposite, libXext, libXfixes, libXrender, libXtst, libXScrnSaver
, nss, nspr, alsaLib, cups, expat, udev, xdg_utils, hunspell
}:
let
  rpath = lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gnome2.GConf
    gtk2
    pango
    hunspell
    libnotify
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    nspr
    nss
    stdenv.cc.cc
    udev
    xdg_utils
    xorg.libxcb
  ];

  version = "3.2.2840";

  plat = {
    "i686-linux" = "i386";
    "x86_64-linux" = "amd64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "i686-linux" = "071ddh2d8wmiybwafwyb97962zj358l0fq7g2r44231653sgybvq";
    "x86_64-linux" = "0qp9ms94smnm7k47b0n0jdzvnm1b7gj25hyinsfc6lghrb6jqw3r";
  }.${stdenv.hostPlatform.system};

in
  stdenv.mkDerivation rec {
    name = "wire-desktop-${version}";

    src = fetchurl {
      url = "https://wire-app.wire.com/linux/debian/pool/main/wire_${version}_${plat}.deb";
      inherit sha256;
    };

    desktopItem = makeDesktopItem {
      name = "wire-desktop";
      exec = "wire-desktop %U";
      icon = "wire-desktop";
      comment = "Secure messenger for everyone";
      desktopName = "Wire Desktop";
      genericName = "Secure messenger";
      categories = "Network;InstantMessaging;Chat;VideoConference";
    };

    phases = [ "unpackPhase" "installPhase" ];
    nativeBuildInputs = [ dpkg ];
    unpackPhase = "dpkg-deb -x $src .";
    installPhase = ''
      mkdir -p $out
      cp -R opt $out
      cp -R usr/share $out/share

      chmod -R g-w $out

      # Patch signal
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
               --set-rpath "${rpath}:$out/opt/wire-desktop" \
               "$out/opt/wire-desktop/wire-desktop"

      # Symlink to bin
      mkdir -p $out/bin
      ln -s "$out/opt/wire-desktop/wire-desktop" $out/bin/wire-desktop

      # Desktop file
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications
    '';

    meta = {
      description = "A modern, secure messenger";
      homepage    = https://wire.com/;
      license     = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [ worldofpeace ];
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  }

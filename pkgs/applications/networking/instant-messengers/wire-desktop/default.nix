{ stdenv, fetchurl, dpkg, makeDesktopItem, libuuid, gtk3, atk, cairo, pango
, gdk_pixbuf, glib, freetype, fontconfig, dbus, libnotify, libX11, xorg, libXi
, libXcursor, libXdamage, libXrandr, libXcomposite, libXext, libXfixes
, libXrender, libXtst, libXScrnSaver, nss, nspr, alsaLib, cups, expat, udev
, xdg_utils, hunspell, pulseaudio, pciutils, at-spi2-atk
}:

let

  rpath = stdenv.lib.makeLibraryPath [
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
    gtk3
    at-spi2-atk
    hunspell
    libuuid
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
    pango
    pciutils
    pulseaudio
    stdenv.cc.cc
    udev
    xdg_utils
    xorg.libxcb
  ];

in

stdenv.mkDerivation rec {
  pname = "wire-desktop";
  version = "3.9.2895";

  src = fetchurl {
    url = "https://wire-app.wire.com/linux/debian/pool/main/Wire-${version}_amd64.deb";
    sha256 = "0wrn95m64j4b7ym44h9zawq13kg4m12aixlyyzp56bfyczmjq4a5";
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

  dontBuild = true;
  dontPatchELF = true;
  dontConfigure = true;

  nativeBuildInputs = [ dpkg ];
  unpackPhase = "dpkg-deb -x $src .";
  installPhase = ''
    mkdir -p "$out"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"

    chmod -R g-w "$out"

    # Patch wire-desktop
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${rpath}:$out/opt/Wire" \
      "$out/opt/Wire/wire-desktop"

    # Symlink to bin
    mkdir -p "$out/bin"
    ln -s "$out/opt/Wire/wire-desktop" "$out/bin/wire-desktop"

    # Desktop file
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  meta = with stdenv.lib; {
    description = "A modern, secure messenger";
    homepage = https://wire.com/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = [ "x86_64-linux" ];
  };
}

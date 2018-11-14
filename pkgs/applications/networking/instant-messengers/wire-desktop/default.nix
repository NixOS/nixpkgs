{ stdenv, fetchurl, dpkg, makeDesktopItem, gnome2, gtk2, atk, cairo, pango, gdk_pixbuf, glib
, freetype, fontconfig, dbus, libnotify, libX11, xorg, libXi, libXcursor, libXdamage
, libXrandr, libXcomposite, libXext, libXfixes, libXrender, libXtst, libXScrnSaver
, nss, nspr, alsaLib, cups, expat, udev, xdg_utils, hunspell, pulseaudio, pciutils
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
    gnome2.GConf
    gtk2
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
    pango
    pciutils
    pulseaudio
    stdenv.cc.cc
    udev
    xdg_utils
    xorg.libxcb
  ];

  version = "3.3.2872";

  plat = {
    "i686-linux" = "i386";
    "x86_64-linux" = "amd64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "i686-linux" = "16dw4ycajxviqrf4i32rkrhg1j1mdkmk252y8vjwr18xlyn958qb";
    "x86_64-linux" = "04ysk91h2izyb41b243zki4j08bis9yzjq2va9bakp1lv6ywm8pw";
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
      homepage    = https://wire.com/;
      license     = licenses.gpl3;
      maintainers = with maintainers; [ worldofpeace ];
      platforms   = [ "i686-linux" "x86_64-linux" ];
    };
  }

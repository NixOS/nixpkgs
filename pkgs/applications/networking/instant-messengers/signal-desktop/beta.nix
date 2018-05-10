{ stdenv, lib, fetchurl, dpkg, gnome2, atk, cairo, gdk_pixbuf, glib, freetype,
fontconfig, dbus, libX11, xorg, libXi, libXcursor, libXdamage, libXrandr,
libXcomposite, libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nss,
nspr, alsaLib, cups, expat, udev
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
    gnome2.gtk
    gnome2.pango
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    nspr
    nss
    stdenv.cc.cc
    udev
    xorg.libxcb
  ];

in
  stdenv.mkDerivation rec {
    name = "signal-desktop-${version}";

    version = "1.1.0-beta.5";

    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop-beta/signal-desktop-beta_${version}_amd64.deb";
          sha256 = "1kllym2iazp9i5afrh0vmsqqlh5b8i6f929p5yhl8bl4zd17zwpx";
        }
      else
        throw "Signal for Desktop is not currently supported on ${stdenv.system}";

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
               --set-rpath "${rpath}:$out/opt/Signal Beta" \
               "$out/opt/Signal Beta/signal-desktop-beta"

      # Symlink to bin
      mkdir -p $out/bin
      ln -s "$out/opt/Signal Beta/signal-desktop-beta" $out/bin/signal-desktop-beta

      # Fix the desktop link
      substituteInPlace $out/share/applications/signal-desktop-beta.desktop \
        --replace "/opt/Signal Beta/signal-desktop-beta" $out/bin/signal-desktop-beta
    '';

    meta = {
      description = "Signal Private Messenger for the Desktop (Beta version)";
      homepage    = https://signal.org/;
      license     = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [ ixmatus benley ];
      platforms   = [
        "x86_64-linux"
      ];
      # Marked as broken on 2018-04-17. Reason: The most recent version is
      # 1.8.0-beta.1, while this is still 1.1.0-beta.5 (2017-12-09). The stable
      # package (signal-desktop) should be used instead (currently at version
      # 1.7.1, i.e. up-to-date).
      broken = true;
    };
  }

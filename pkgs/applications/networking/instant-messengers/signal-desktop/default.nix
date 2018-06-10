{ stdenv, lib, fetchurl, dpkg, wrapGAppsHook
, gnome3, gtk3, atk, cairo, pango, gdk_pixbuf, glib, freetype, fontconfig
, dbus, libX11, xorg, libXi, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nss, nspr, alsaLib
, cups, expat, udev
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
    gnome3.gconf
    gtk3
    pango
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

in stdenv.mkDerivation rec {
  name = "signal-desktop-${version}";
  version = "1.12.0";

  src = fetchurl {
    url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
    sha256 = "19c9pilx2qkpyqw3p167bfcizrpd4np5jxdcwqmpbcfibmrpmcsk";
  };

  phases = [ "unpackPhase" "installPhase" ];

  nativeBuildInputs = [ dpkg wrapGAppsHook ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out
    cp -R opt $out

    mv ./usr/share $out/share
    mv $out/opt/Signal $out/libexec
    rmdir $out/opt

    chmod -R g-w $out

    # Patch signal
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath ${rpath}:$out/libexec $out/libexec/signal-desktop
    wrapProgram $out/libexec/signal-desktop \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      "''${gappsWrapperArgs[@]}"

    # Symlink to bin
    mkdir -p $out/bin
    ln -s $out/libexec/signal-desktop $out/bin/signal-desktop

    # Fix the desktop link
    substituteInPlace $out/share/applications/signal-desktop.desktop \
      --replace /opt/Signal/signal-desktop $out/bin/signal-desktop
  '';

  meta = {
    description = "Private, simple, and secure messenger";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage    = https://signal.org/;
    license     = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ixmatus primeos ];
    platforms   = [ "x86_64-linux" ];
  };
}

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

    version = "1.6.1";

    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
          sha256 = "0q2qzl84ifnhcn1qbq38fdpj8ry748h6dlzp2mdpkslsh8mc46as";
        }
      else
        throw "Signal for Desktop is not currently supported on ${stdenv.system}";

    phases = [ "unpackPhase" "installPhase" ];
    nativeBuildInputs = [ dpkg ];
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

      # Symlink to bin
      mkdir -p $out/bin
      ln -s $out/libexec/signal-desktop $out/bin/signal-desktop

      # Fix the desktop link
      substituteInPlace $out/share/applications/signal-desktop.desktop \
        --replace /opt/Signal/signal-desktop $out/bin/signal-desktop
    '';

    meta = {
      description = "Signal Private Messenger for the Desktop.";
      homepage    = https://signal.org/;
      license     = lib.licenses.gpl3;
      maintainers = [ lib.maintainers.ixmatus ];
      platforms   = [
        "x86_64-linux"
      ];
    };
  }

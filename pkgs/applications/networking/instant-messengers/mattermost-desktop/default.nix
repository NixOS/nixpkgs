{ stdenv, lib, fetchurl, gnome2, gtk2, pango, atk, cairo, gdk_pixbuf, glib,
freetype, fontconfig, dbus, libX11, xorg, libXi, libXcursor, libXdamage,
libXrandr, libXcomposite, libXext, libXfixes, libXrender, libXtst,
libXScrnSaver, nss, nspr, alsaLib, cups, expat, udev }:
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
    name = "mattermost-desktop-${version}";
    version = "4.1.2";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${name}-linux-x64.tar.gz";
          sha256 = "16dn6870bs1nfl2082ym9gwvmqb3i5sli48qprap80p7riph6k9s";
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${name}-linux-ia32.tar.gz";
          sha256 = "145zb1l37fa2slfrrlprlwzcc5km3plxs374yhgix25mlg2afkqr";
        }
      else
        throw "Mattermost-Desktop is not currently supported on ${stdenv.hostPlatform.system}";

    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out
      cp -R . $out

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
               --set-rpath ${rpath}:$out $out/mattermost-desktop

      patchShebangs $out/create_desktop_file.sh
      $out/create_desktop_file.sh

      mkdir -p $out/{bin,share/applications}
      cp Mattermost.desktop $out/share/applications/Mattermost.desktop
      ln -s $out/mattermost-desktop $out/bin/mattermost-desktop
    '';

    meta = {
      description = "Mattermost Desktop client";
      homepage    = https://about.mattermost.com/;
      license     = lib.licenses.asl20;
      platforms   = [
        "x86_64-linux" "i686-linux"
      ];
    };
  }

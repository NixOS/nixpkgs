{ stdenv, fetchurl, binutils, patchelf, expat, xorg, gdk_pixbuf, glib, gnome2, cairo, atk, freetype, fontconfig, dbus, nss, nspr, gtk2-x11, alsaLib, cups }:

stdenv.mkDerivation rec {
  name = "inboxer-${version}";
  version = "1.0.0";

  meta = with stdenv.lib; {
    description = "Unofficial, free and open-source Google Inbox Desktop App";
    homepage    = "https://denysdovhan.com/inboxer";
    maintainers = [ maintainers.mgttlinger ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };

  src = fetchurl {
    url = "https://github.com/denysdovhan/inboxer/releases/download/v${version}/inboxer_${version}_amd64.deb";
    sha256 = "01384fi5vrfqpznk9389nf3bwpi2zjbnkg84g6z1css8f3gp5i1c";
  };

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ
  '';
  buildInputs = [ binutils patchelf ];

  preFixup = with stdenv.lib; let
    lpath = makeLibraryPath [
      alsaLib
      atk
      cairo
      cups
      dbus
      nss
      nspr
      freetype
      fontconfig
      gtk2-x11
      xorg.libX11
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXi
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libXrender
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXScrnSaver
      xorg.libxcb
      gdk_pixbuf
      glib
      gnome2.pango
      gnome2.GConf
      expat
      stdenv.cc.cc.lib
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/opt/Inboxer:${lpath}" \
      $out/opt/Inboxer/inboxer
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp -R usr/share opt $out/
    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/inboxer.desktop \
      --replace /opt/ $out/opt/
    # symlink the binary to bin/
    ln -s $out/opt/Inboxer/inboxer $out/bin/inboxer
  '';
}

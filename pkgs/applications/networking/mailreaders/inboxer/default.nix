{ stdenv, fetchurl, binutils, patchelf, makeWrapper, expat, xorg, gdk_pixbuf, glib, gnome2, cairo, atk, freetype, fontconfig, dbus, nss, nspr, gtk2-x11, alsaLib, cups, libpulseaudio, libudev }:

stdenv.mkDerivation rec {
  name = "inboxer-${version}";
  version = "1.0.2";

  meta = with stdenv.lib; {
    description = "Unofficial, free and open-source Google Inbox Desktop App";
    homepage    = "https://denysdovhan.com/inboxer";
    maintainers = [ maintainers.mgttlinger ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };

  src = fetchurl {
    url = "https://github.com/denysdovhan/inboxer/releases/download/v${version}/inboxer_${version}_amd64.deb";
    sha256 = "0nqgsqxsjnj46wsfb60p7fr631yx3fx7dfa4fpj6x2ml4i42kxid";
  };

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ
  '';
  buildInputs = [ binutils patchelf makeWrapper ];

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
      libpulseaudio
      libudev
    ];
  in ''
    patchelf \
      --set-rpath "$out/opt/Inboxer:${lpath}" \
      $out/opt/Inboxer/libnode.so
    patchelf \
      --set-rpath "$out/opt/Inboxer:${lpath}" \
      $out/opt/Inboxer/libffmpeg.so
   
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/opt/Inboxer:${lpath}" \
      $out/opt/Inboxer/inboxer

    wrapProgram $out/opt/Inboxer/inboxer --set LD_LIBRARY_PATH "${xorg.libxkbfile}/lib:${lpath}"
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

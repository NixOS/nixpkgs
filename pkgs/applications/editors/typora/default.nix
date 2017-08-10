{ stdenv, fetchurl, dpkg, lib, glib, dbus, makeWrapper, gnome2, atk, cairo
, freetype, fontconfig, nspr, nss, xorg, alsaLib, cups, expat, udev }:

stdenv.mkDerivation rec {
  name = "typora-${version}";
  version = "0.9.31";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
        sha256 = "786b5164d9c63ecc23eb427c5ff393285ce8fd540c5bfdd5c1464655fac87a42";
      }
    else
      fetchurl {
        url = "https://www.typora.io/linux/typora_${version}_i386.deb";
        sha256 = "a8fe53f8984d9f8c4e06c14affbb616be58a91cd2b475b9681fb18a6e21930d1";
      }
    ;

    rpath = stdenv.lib.makeLibraryPath [
      alsaLib
      gnome2.GConf
      gnome2.gtk
      gnome2.gdk_pixbuf
      gnome2.pango
      expat
      atk
      nspr
      nss
      stdenv.cc.cc
      glib
      cairo
      cups
      dbus
      udev
      fontconfig
      freetype
      xorg.libX11
      xorg.libXi
      xorg.libXext
      xorg.libXtst
      xorg.libXfixes
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXrender
      xorg.libXrandr
      xorg.libXcomposite
      xorg.libxcb
      xorg.libXScrnSaver
  ];


  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm $out/bin/typora

    # Otherwise it looks "suspicious"
    chmod -R g-w $out
  '';

  postFixup = ''
     patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/share/typora:${rpath}" "$out/share/typora/Typora"

    ln -s "$out/share/typora/Typora" "$out/bin/typora"

    # Fix the desktop link
    substituteInPlace $out/share/applications/typora.desktop \
      --replace /usr/bin/ $out/bin/ \
      --replace /usr/share/ $out/share/

  '';

  meta = with stdenv.lib; {
    description = "A minimal Markdown reading & writing app";
    homepage = https://typora.io;
    license = licenses.free;
    maintainers = with stdenv.lib.maintainers; [ jensbin ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}


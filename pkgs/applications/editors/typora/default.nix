{ stdenv, fetchurl, dpkg, lib, glib, dbus, makeWrapper, gnome2, atk, cairo
, freetype, fontconfig, nspr, nss, xorg, alsaLib, cups, expat, udev }:

stdenv.mkDerivation rec {
  name = "typora-${version}";
  version = "0.9.44";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
        sha256 = "9442c090bf2619d270890228abd7dabb9e217c0b200615f8ed3cb255efd122d5";
      }
    else
      fetchurl {
        url = "https://www.typora.io/linux/typora_${version}_i386.deb";
        sha256 = "ae228ca946d03940b85df30c995c4de3f942a780e32d4dcab872dec671c66ef3";
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
    mv $out/usr/bin $out
    mv $out/usr/share $out
    rm $out/bin/typora
    rmdir $out/usr

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
    license = licenses.unfree;
    maintainers = with maintainers; [ jensbin ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

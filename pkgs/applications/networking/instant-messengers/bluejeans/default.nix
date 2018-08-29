{ stdenv, fetchurl, patchelf, rpmextract,
alsaLib, atk, cairo, dbus, expat, fontconfig, freetype, gdk_pixbuf, glib,
gnome2, gtk2, libXi, libcap, libnotify, libudev0-shim, nspr, nss, pango, xorg
}:

let

  rpath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc.lib
    alsaLib
    atk
    cairo
    dbus.lib
    expat
    fontconfig.lib
    freetype
    gdk_pixbuf
    glib
    gnome2.GConf
    gtk2
    libcap.lib
    libnotify
    libudev0-shim
    nspr
    nss
    pango.out
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
  ];

in

stdenv.mkDerivation rec {
  name = "bluejeans-${version}";
  version = "1.36.9";

  src = fetchurl {
    url = "https://swdl.bluejeans.com/desktop/linux/1.36/${version}/bluejeans-${version}.x86_64.rpm";
    sha256 = "0sbv742pzqd2cxn3kq10lfi16jah486i9kyrmi8l1rpb9fhyw2m1";
  };

  unpackCmd = "rpmextract $curSrc";
  sourceRoot = ".";

  nativeBuildInputs = [ patchelf rpmextract ];

  installPhase = ''
    mkdir "$out"
    mv opt "$out"/

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${rpath}" \
      "$out"/opt/bluejeans/bluejeans-bin

    mkdir "$out"/bin
    ln -s "$out"/opt/bluejeans/bluejeans-bin "$out"/bin/bluejeans
  '';

  meta = with stdenv.lib; {
    description = "Bluejeans desktop client";
    homepage = http://www.bluejeans.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ veprbl ];
  };
}

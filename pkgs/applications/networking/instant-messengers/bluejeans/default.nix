{ stdenv
, fetchurl
, rpmextract
, patchelf
, libnotify
, libcap
, cairo
, pango
, fontconfig
, udev
, dbus
, gtk2
, atk
, expat
, gdk-pixbuf
, freetype
, nspr
, glib
, nss
, gconf
, libX11
, libXrender
, libXtst
, libXdamage
, libXi
, libXext
, libXfixes
, libXcomposite
, alsaLib
, bash
}:

stdenv.mkDerivation rec {
  pname = "bluejeans";
  version = "1.36.9";

  src =
    fetchurl {
      url = "https://swdl.bluejeans.com/desktop/linux/1.36/${version}/bluejeans-${version}.x86_64.rpm";
      sha256 = "0sbv742pzqd2cxn3kq10lfi16jah486i9kyrmi8l1rpb9fhyw2m1";
    };

  nativeBuildInputs = [ patchelf rpmextract ];

  libPath =
    stdenv.lib.makeLibraryPath
      [
        libnotify
        libcap
        cairo
        pango
        fontconfig
        gtk2
        atk
        expat
        gdk-pixbuf
        dbus
        udev.lib
        freetype
        nspr
        glib
        stdenv.cc
        stdenv.cc.cc.lib
        nss
        gconf
        libX11
        libXrender
        libXtst
        libXdamage
        libXi
        libXext
        libXfixes
        libXcomposite
        alsaLib
      ];

  buildCommand = ''
    mkdir -p $out/bin/
    cd $out
    rpmextract $src
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      opt/bluejeans/bluejeans-bin
    patchelf \
      --set-rpath ${libPath} \
      opt/bluejeans/bluejeans-bin
    patchelf \
      --replace-needed libudev.so.0 libudev.so.1 \
      opt/bluejeans/bluejeans-bin
    ln -s $out/opt/bluejeans/bluejeans $out/bin/bluejeans
    chmod +x $out/bin/bluejeans
    patchShebangs $out
  '';

  meta = with stdenv.lib; {
    description = "Video, audio, and web conferencing that works together with the collaboration tools you use every day.";
    homepage = "https://www.bluejeans.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ veprbl ];
    platforms = [ "x86_64-linux" ];
  };
}

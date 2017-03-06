{ stdenv, callPackage, overrideCC, fetchurl, makeWrapper, pkgconfig
, zip, python, zlib, which, icu, libmicrohttpd, lzma, ctpp2, aria2, wget, bc
, libuuid, glibc, libX11, libXext, libXt, libXrender, glib, dbus, dbus_glib
, gtk2, gdk_pixbuf, pango, cairo , freetype, fontconfig, alsaLib, atk
}:

let
  xulrunner64_tar = fetchurl {
    url = http://download.kiwix.org/dev/xulrunner-29.0.en-US.linux-x86_64.tar.bz2;
    sha256 = "0i3m30gm5z7qmas14id6ypvbmnb2k7jhz8aby2wz5vvv49zqmx3s";
  };
  xulrunnersdk64_tar = fetchurl {
    url = http://download.kiwix.org/dev/xulrunner-29.0.en-US.linux-x86_64.sdk.tar.bz2;
    sha256 = "0z90v7c4mq15g5klmsj8vs2r10fbygj3qzynx4952hkv8ihw8n3a";
  };
  xulrunner32_tar = fetchurl {
    url = http://download.kiwix.org/dev/xulrunner-29.0.en-US.linux-i686.tar.bz2;
    sha256 = "0yln6pxz8f6b9wm9124sx049z8mgi17lgd63rcv2hnix825y8gjb";
  };
  xulrunnersdk32_tar = fetchurl {
    url = http://download.kiwix.org/dev/xulrunner-29.0.en-US.linux-i686.sdk.tar.bz2;
    sha256 = "1h9vcbvf8wgds6i2z20y7krpys0mqsqhv1ijyfljanp6vyll9fvi";
  };

  xulrunner_tar = if stdenv.system == "x86_64-linux" then xulrunner64_tar else xulrunner32_tar;
  xulrunnersdk_tar = if stdenv.system == "x86_64-linux" then xulrunnersdk64_tar else xulrunnersdk32_tar;
  pugixml_tar = fetchurl {
    url = http://download.kiwix.org/dev/pugixml-1.2.tar.gz;
    sha256 = "0sqk0vdwjq44jxbbkj1cy8qykrmafs1sickzldb2w2nshsnjshhg";
  };

  xapian = callPackage ../../../development/libraries/xapian { inherit stdenv; };
  zimlib = callPackage ../../../development/libraries/zimlib { inherit stdenv; };

in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "kiwix-${version}";
  version = "0.9";

  src = fetchurl {
    url = "http://download.kiwix.org/src/kiwix-${version}-src.tar.xz";
    sha256 = "0577phhy2na59cpcqjgldvksp0jwczyg0l6c9ghnr19i375l7yqc";
  };

  buildInputs = [
    zip
    pkgconfig
    python
    zlib
    xapian
    which
    icu
    libmicrohttpd
    lzma
    zimlib
    ctpp2
    aria2
    wget
    bc
    libuuid
    makeWrapper
  ];

  postUnpack = ''
    cd kiwix-*
    mkdir static
    cp Makefile.in static/

    cd src/dependencies
    cp ${pugixml_tar} pugixml-1.2.tar.gz

    tar -xf ${xulrunner_tar}
    tar -xf ${xulrunnersdk_tar}

    cd ../../..
  '';

  configurePhase = ''
    bash ./configure --disable-static --disable-dependency-tracking --prefix=$out --with-libpugixml=SELF
  '';

  buildPhase = ''
    cd src/dependencies
    make pugixml-1.2/libpugixml.a

    cd ../..
    bash ./configure --disable-static --disable-dependency-tracking --prefix=$out --with-libpugixml=SELF

    make
  '';

  installPhase = ''
    make install
    cp -r src/dependencies/xulrunner $out/lib/kiwix

    patchelf --set-interpreter ${glibc.out}/lib/ld-linux${optionalString (stdenv.system == "x86_64-linux") "-x86-64"}.so.2 $out/lib/kiwix/xulrunner/xulrunner

    rm $out/bin/kiwix
    makeWrapper $out/lib/kiwix/kiwix-launcher $out/bin/kiwix \
      --suffix LD_LIBRARY_PATH : ${makeLibraryPath [stdenv.cc.cc libX11 libXext libXt libXrender glib dbus dbus_glib gtk2 gdk_pixbuf pango cairo freetype fontconfig alsaLib atk]} \
      --suffix PATH : ${aria2}/bin
  '';

  meta = {
    description = "An offline reader for Web content";
    homepage = http://kiwix.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ robbinch ];
  };
}

{ stdenv, fetchurl, makeWrapper, pkgconfig
, zip, python, zlib, which, icu, libmicrohttpd, lzma, aria2, wget, bc
, libuuid, glibc, libX11, libXext, libXt, libXrender, glib, dbus, dbus_glib
, gtk2, gdk_pixbuf, pango, cairo, freetype, fontconfig, alsaLib, atk, cmake
, xapian, ctpp2, zimlib
}:

with stdenv.lib;

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

  xulrunner = if stdenv.system == "x86_64-linux"
              then { tar = xulrunner64_tar; sdk = xulrunnersdk64_tar; }
              else { tar = xulrunner32_tar; sdk = xulrunnersdk32_tar; };

  ctpp2_ = ctpp2.override { inherit stdenv; };
  xapian_ = xapian.override { inherit stdenv; };
  zimlib_ = zimlib.override { inherit stdenv; };

  pugixml = stdenv.mkDerivation rec {
    version = "1.2";
    name = "pugixml-${version}";

    src = fetchurl {
      url = "http://download.kiwix.org/dev/${name}.tar.gz";
      sha256 = "0sqk0vdwjq44jxbbkj1cy8qykrmafs1sickzldb2w2nshsnjshhg";
    };

    buildInputs = [ cmake ];

    unpackPhase = ''
      # not a nice src archive: all the files are in the root :(
      mkdir ${name}
      cd ${name}
      tar -xf ${src}

      # and the build scripts are in there :'(
      cd scripts
    '';
  };

in

stdenv.mkDerivation rec {
  name = "kiwix-${version}";
  version = "0.9";

  src = fetchurl {
    url = "http://download.kiwix.org/src/kiwix-${version}-src.tar.xz";
    sha256 = "0577phhy2na59cpcqjgldvksp0jwczyg0l6c9ghnr19i375l7yqc";
  };

  buildInputs = [
    zip pkgconfig python zlib xapian_ which icu libmicrohttpd
    lzma zimlib_ ctpp2_ aria2 wget bc libuuid makeWrapper pugixml
  ];

  postUnpack = ''
    cd kiwix*
    mkdir static
    cp Makefile.in static/

    cd src/dependencies

    tar -xf ${xulrunner.tar}
    tar -xf ${xulrunner.sdk}

    cd ../../..
  '';

  configureFlags = [
    "--disable-static"
    "--disable-staticbins"
  ];

  postInstall = ''
    cp -r src/dependencies/xulrunner $out/lib/kiwix

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/lib/kiwix/xulrunner/xulrunner

    rm $out/bin/kiwix
    makeWrapper $out/lib/kiwix/kiwix-launcher $out/bin/kiwix \
      --suffix LD_LIBRARY_PATH : ${makeLibraryPath [stdenv.cc.cc libX11 libXext libXt libXrender glib dbus dbus_glib gtk2 gdk_pixbuf pango cairo freetype fontconfig alsaLib atk]} \
      --suffix PATH : ${aria2}/bin
  '';

  meta = {
    description = "An offline reader for Web content";
    homepage = http://kiwix.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ robbinch ];
  };
}

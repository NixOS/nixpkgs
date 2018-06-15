{ lib, stdenv, fetchurl, qt4, pkgconfig, boost, expat, cairo, python2Packages,
  cmake, flex, bison, pango, librsvg, librevenge, libxml2, libcdr, libzip,
  poppler, imagemagick, glew, openexr, ffmpeg, opencolorio, openimageio,
  qmake4Hook, libpng, libGL, lndir }:

let
  minorVersion = "2.1";
  version = "${minorVersion}.9";
  OpenColorIO-Configs = fetchurl {
    url = "https://github.com/MrKepzie/OpenColorIO-Configs/archive/Natron-v${minorVersion}.tar.gz";
    sha256 = "9eec5a02ca80c9cd8e751013cb347ea982fdddd592a4a9215cce462e332dac51";
  };
  seexpr = stdenv.mkDerivation rec {
    version = "1.0.1";
    name = "seexpr-${version}";
    src = fetchurl {
      url = "https://github.com/wdas/SeExpr/archive/rel-${version}.tar.gz";
      sha256 = "1ackh0xs4ip7mk34bam8zd4qdymkdk0dgv8x0f2mf6gbyzzyh7lp";
    };
    nativeBuildInputs = [ cmake ];
    buildInputs = [ libpng flex bison ];
  };
  buildPlugin = { pluginName, sha256, nativeBuildInputs ? [], buildInputs ? [], preConfigure ? "" }:
    stdenv.mkDerivation {
      name = "openfx-${pluginName}-${version}";
      src = fetchurl {
        url = "https://github.com/MrKepzie/Natron/releases/download/${version}/openfx-${pluginName}-${version}.tar.xz";
        inherit sha256;
      };
      inherit nativeBuildInputs buildInputs;
      preConfigure = ''
        makeFlagsArray+=("CONFIG=release")
        makeFlagsArray+=("PLUGINPATH=$out/Plugins/OFX/Natron")
        ${preConfigure}
      '';
    };
  lodepngcpp = fetchurl {
    url = https://raw.githubusercontent.com/lvandeve/lodepng/a70c086077c0eaecbae3845e4da4424de5f43361/lodepng.cpp;
    sha256 = "1dxkkr4jbmvlwfr7m16i1mgcj1pqxg9s1a7y3aavs9rrk0ki8ys2";
  };
  lodepngh = fetchurl {
    url = https://raw.githubusercontent.com/lvandeve/lodepng/a70c086077c0eaecbae3845e4da4424de5f43361/lodepng.h;
    sha256 = "14drdikd0vws3wwpyqq7zzm5z3kg98svv4q4w0hr45q6zh6hs0bq";
  };
  CImgh = fetchurl {
    url = https://raw.githubusercontent.com/dtschump/CImg/572c12d82b2f59ece21be8f52645c38f1dd407e6/CImg.h;
    sha256 = "0n4qfxj8j6rmj4svf68gg2pzg8d1pb74bnphidnf8i2paj6lwniz";
  };
  plugins = map buildPlugin [
    ({
      pluginName = "arena";
      sha256 = "0qba13vn9qdfax7nqlz1ps27zspr5kh795jp1xvbmwjzjzjpkqkf";
      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [
        pango librsvg librevenge libcdr opencolorio libxml2 libzip
        poppler imagemagick
      ];
      preConfigure = ''
        sed -i 's|pkg-config poppler-glib|pkg-config poppler poppler-glib|g' Makefile.master
        for i in Extra Bundle; do
          cp ${lodepngcpp} $i/lodepng.cpp
          cp ${lodepngh} $i/lodepng.h
        done
      '';
    })
    ({
      pluginName = "io";
      sha256 = "0s196i9fkgr9iw92c94mxgs1lkxbhynkf83vmsgrldflmf0xjky7";
      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [
        libpng ffmpeg openexr opencolorio openimageio boost libGL
        seexpr
      ];
    })
    ({
      pluginName = "misc";
      sha256 = "02h79jrll0c17azxj16as1mks3lmypm4m3da4mms9sg31l3n82qi";
      buildInputs = [
        libGL
      ];
      preConfigure = ''
        cp ${CImgh} CImg/CImg.h
      '';
    })
  ];
in
stdenv.mkDerivation {
  inherit version;
  name = "natron-${version}";

  src = fetchurl {
    url = "https://github.com/MrKepzie/Natron/releases/download/${version}/Natron-${version}.tar.xz";
    sha256 = "1wdc0zqriw2jhlrhzs6af3kagrv22cm086ffnbr1x43mgc9hfhjp";
  };

  nativeBuildInputs = [ qmake4Hook pkgconfig python2Packages.wrapPython ];

  buildInputs = [
    qt4 boost expat cairo python2Packages.pyside python2Packages.pysideShiboken
  ];

  preConfigure = ''
    export MAKEFLAGS=-j$NIX_BUILD_CORES
    cp ${./config.pri} config.pri
    mkdir OpenColorIO-Configs
    tar -xf ${OpenColorIO-Configs} --strip-components=1 -C OpenColorIO-Configs
  '';

  postFixup = ''
    for i in ${lib.escapeShellArgs plugins}; do
      ${lndir}/bin/lndir $i $out
    done
    wrapProgram $out/bin/Natron \
      --set PYTHONPATH "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    description = "Node-graph based, open-source compositing software";
    longDescription = ''
      Node-graph based, open-source compositing software. Similar in
      functionalities to Adobe After Effects and Nuke by The Foundry.
    '';
    homepage = https://natron.inria.fr/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.puffnfresh ];
    platforms = platforms.linux;
    broken = true;
  };
}

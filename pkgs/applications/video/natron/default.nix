{ lib, stdenv, fetchurl, qt4, pkg-config, boost, expat, cairo, python2Packages,
  cmake, flex, bison, pango, librsvg, librevenge, libxml2, libcdr, libzip,
  poppler, imagemagick, openexr, ffmpeg, opencolorio_1, openimageio_1,
  qmake4Hook, libpng, libGL, lndir, libraw, openjpeg, libwebp, fetchFromGitHub }:

let
  minorVersion = "2.3";
  version = "${minorVersion}.15";
  OpenColorIO-Configs = fetchurl {
    url = "https://github.com/NatronGitHub/OpenColorIO-Configs/archive/Natron-v${minorVersion}.tar.gz";
    sha256 = "AZK9J+RnMyxOYcAQOAQZj5QciPQ999m6jrtBt5rdpkA=";
  };
  seexpr = stdenv.mkDerivation rec {
    version = "1.0.1";
    pname = "seexpr";
    src = fetchurl {
      url = "https://github.com/wdas/SeExpr/archive/rel-${version}.tar.gz";
      sha256 = "1ackh0xs4ip7mk34bam8zd4qdymkdk0dgv8x0f2mf6gbyzzyh7lp";
    };
    nativeBuildInputs = [ cmake ];
    buildInputs = [ libpng flex bison ];
  };
  buildPlugin = { pluginName, sha256, nativeBuildInputs ? [], buildInputs ? [], preConfigure ? "", postPatch ? "" }:
    stdenv.mkDerivation {
      pname = "openfx-${pluginName}";
      version = version;
      src = fetchurl {
        url = "https://github.com/NatronGitHub/openfx-${pluginName}/releases/download/Natron-${version}/openfx-${pluginName}-Natron-${version}.tar.xz";
        inherit sha256;
      };
      inherit nativeBuildInputs buildInputs postPatch;
      preConfigure = ''
        makeFlagsArray+=("CONFIG=release")
        makeFlagsArray+=("PLUGINPATH=$out/Plugins/OFX/Natron")
        ${preConfigure}
      '';
    };
  lodepngcpp = fetchurl {
    url = "https://raw.githubusercontent.com/lvandeve/lodepng/a70c086077c0eaecbae3845e4da4424de5f43361/lodepng.cpp";
    sha256 = "1dxkkr4jbmvlwfr7m16i1mgcj1pqxg9s1a7y3aavs9rrk0ki8ys2";
  };
  lodepngh = fetchurl {
    url = "https://raw.githubusercontent.com/lvandeve/lodepng/a70c086077c0eaecbae3845e4da4424de5f43361/lodepng.h";
    sha256 = "14drdikd0vws3wwpyqq7zzm5z3kg98svv4q4w0hr45q6zh6hs0bq";
  };
  cimgversion = "89b9d062ec472df3d33989e6d5d2a8b50ba0775c";
  CImgh = fetchurl {
    url = "https://raw.githubusercontent.com/dtschump/CImg/${cimgversion}/CImg.h";
    sha256 = "sha256-NbYpZDNj2oZ+wqoEkRwwCjiujdr+iGOLA0Pa0Ynso6U=";
  };
  inpainth = fetchurl {
    url = "https://raw.githubusercontent.com/dtschump/CImg/${cimgversion}/plugins/inpaint.h";
    sha256 = "sha256-cd28a3VOs5002GkthHkbIUrxZfKuGhqIYO4Oxe/2HIQ=";
  };
  plugins = map buildPlugin [
    ({
      pluginName = "arena";
      sha256 = "tUb6myG03mRieUAfgRZfv5Ap+cLvbpNrLMYCGTiAq8c=";
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        pango librsvg librevenge libcdr opencolorio_1 libxml2 libzip
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
      sha256 = "OQg6a5wNy9TFFySjmgd1subvXRxY/ZnSOCkaoUo+ZaA=";
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libpng ffmpeg openexr opencolorio_1 openimageio_1 boost libGL
        seexpr libraw openjpeg libwebp
      ];
    })
    ({
      pluginName = "misc";
      sha256 = "XkdQyWI9ilF6IoP3yuHulNUZRPLX1m4lq/+RbXsrFEQ=";
      buildInputs = [
        libGL
      ];
      postPatch = ''
        cp '${inpainth}' CImg/Inpaint/inpaint.h
        patch -p0 -dCImg < CImg/Inpaint/inpaint.h.patch # taken from the Makefile; it gets skipped if the file already exists
        cp '${CImgh}' CImg/CImg.h
      '';
    })
  ];
in
stdenv.mkDerivation {
  inherit version;
  pname = "natron";

  src = fetchFromGitHub {
    owner = "NatronGitHub";
    repo = "Natron";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-KuXJmmIsvwl4uqmAxXqWU+273jsdWrCuUSwWn5vuu8M=";
  };

  nativeBuildInputs = [ qmake4Hook pkg-config python2Packages.wrapPython ];

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

  meta = with lib; {
    description = "Node-graph based, open-source compositing software";
    longDescription = ''
      Node-graph based, open-source compositing software. Similar in
      functionalities to Adobe After Effects and Nuke by The Foundry.
    '';
    homepage = "https://natron.fr/";
    license = lib.licenses.gpl2;
    maintainers = [ maintainers.puffnfresh ];
    platforms = platforms.linux;
    broken = true; # Last evaluated on Hydra on 2021-05-18
  };
}

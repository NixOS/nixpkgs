{ lib, stdenv, fetchurl, qt4, pkg-config, boost, expat, cairo, python2Packages,
  cmake, flex, bison, pango, librsvg, librevenge, libxml2, libcdr, libzip,
  poppler, imagemagick, openexr, ffmpeg, opencolorio, openimageio,
  qmake4Hook, libpng, libGL, lndir, libraw, openjpeg, libwebp, fetchFromGitHub }:

let
  minorVersion = "2.4";
  version = "${minorVersion}.0";
  OpenColorIO-Configs = fetchurl {
    url = "https://github.com/NatronGitHub/OpenColorIO-Configs/archive/Natron-v${minorVersion}.tar.gz";
    sha256 = "sha256-MvHC+U2KMdTj+FXl6e8nF4cseHO0p06x6sKYYvunPSw=";
  };
  seexpr = stdenv.mkDerivation rec {
    version = "1.0.1";
    pname = "seexpr";
    src = fetchurl {
      url = "https://github.com/wdas/SeExpr/archive/rel-${version}.tar.gz";
      sha256 = "sha256-lx7o//frGVeFAx3t18Bss/qGSfuoqkXGrOdGojuAk6k=";
    };
    nativeBuildInputs = [ cmake ];
    buildInputs = [ libpng flex bison ];
  };
  buildPlugin = { pluginName, sha256, nativeBuildInputs ? [], buildInputs ? [], preConfigure ? "", postPatch ? "" }:
    stdenv.mkDerivation {
      pname = "openfx-${pluginName}";
      version = version;
      src = fetchFromGitHub {
        owner = "NatronGitHub";
        repo = "openfx-${pluginName}";
        rev = "Natron-${version}";
        fetchSubmodules = true;
        inherit sha256;
      };
      inherit nativeBuildInputs buildInputs postPatch;
      preConfigure = ''
        makeFlagsArray+=("CONFIG=release")
        makeFlagsArray+=("PLUGINPATH=$out/Plugins/OFX/Natron")
        ${preConfigure}
      '';
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
      sha256 = "sha256-fAXQyYnLbFYqwKmkwHSoOGa/0cruHJbf2QLMsttiarM=";
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        pango librsvg librevenge libcdr opencolorio libxml2 libzip
        poppler imagemagick
      ];
      preConfigure = ''
        sed -i 's|pkg-config poppler-glib|pkg-config poppler poppler-glib|g' Makefile.master
      '';
    })
    ({
      pluginName = "io";
      sha256 = "sha256-tt+G2YqHQn8vPdiWtRYuOF3ffz9Qo19oD8Z9DsTDvQQ=";
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libpng ffmpeg openexr opencolorio openimageio boost libGL
        seexpr libraw openjpeg libwebp
      ];
    })
    ({
      pluginName = "misc";
      sha256 = "sha256-xKhlXSsjaSkoKq3IdAG89N8oCI6SihHJpji6Jh2bx/8=";
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
    sha256 = "sha256-YPfkS19cxLH2a3YXjmUgAlPzHeQHgEDPFdXCI3wVoQs=";
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
    maintainers = with maintainers; [ puffnfresh vojta001 ];
    platforms = platforms.linux;
  };
}

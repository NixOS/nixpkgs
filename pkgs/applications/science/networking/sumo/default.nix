{ lib, bzip2, cmake, eigen, fetchFromGitHub, ffmpeg, fox_1_6, gdal,
  git, gl2ps, gpp , gtest, jdk, libGL, libGLU, libX11, libjpeg,
  libpng, libtiff, openscenegraph , proj, python3, python37Packages,
  stdenv, swig, xercesc, xorg, zlib }:

stdenv.mkDerivation rec {
  pname = "sumo";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "sumo";
    rev = "v${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1w9im1zz8xnkdwmv4v11kn1xcqm889268g1fw4y2s9f6shi41mxx";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    swig
  ];

  buildInputs = [
    bzip2
    eigen
    ffmpeg
    fox_1_6
    gdal
    gl2ps
    gpp
    gtest
    jdk
    libGL
    libGLU
    libX11
    libjpeg
    libpng
    libtiff
    openscenegraph
    proj
    python37Packages.setuptools
    xercesc
    zlib
    python3
  ] ++ (with xorg; [
    libXcursor
    libXext
    libXfixes
    libXft
    libXrandr
    libXrender
  ]);

  meta = with lib; {
    description = "The SUMO traffic simulator";
    longDescription = ''
      Eclipse SUMO is an open source, highly
      portable, microscopic and continuous traffic simulation package
      designed to handle large networks. It allows for intermodal
      simulation including pedestrians and comes with a large set of
      tools for scenario creation.
    '';
    homepage = "https://github.com/eclipse/sumo";
    license = licenses.epl20;
    maintainers = with maintainers; [ mtreca ];
  };
}

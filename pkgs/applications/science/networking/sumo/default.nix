{ lib, bzip2, cmake, eigen, fetchFromGitHub, ffmpeg_4, fox_1_6, gdal,
  git, gl2ps, gpp , gtest, jdk, libGL, libGLU, libX11, libjpeg,
  libpng, libtiff, libxcrypt, openscenegraph , proj, python3,
  python3Packages, stdenv, swig, xercesc, xorg, zlib }:

stdenv.mkDerivation rec {
  pname = "sumo";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "sumo";
    rev = "v${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-/MKhec4nhz6juTCc5dNrrDAlzldodGjili4vWkzafPM=";
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
    ffmpeg_4
    fox_1_6
    gdal
    gl2ps
    gpp
    gtest
    jdk
    libGL
    libGLU
    libjpeg
    libpng
    libtiff
    libxcrypt
    openscenegraph
    proj
    python3Packages.setuptools
    xercesc
    zlib
    python3
  ] ++ (with xorg; [
    libX11
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

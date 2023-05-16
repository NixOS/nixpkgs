{ lib, bzip2, cmake, eigen, fetchFromGitHub, ffmpeg_4, fox_1_6, gdal,
  git, gl2ps, gpp , gtest, jdk, libGL, libGLU, libX11, libjpeg,
  libpng, libtiff, libxcrypt, openscenegraph , proj, python3,
  python3Packages, stdenv, swig, xercesc, xorg, zlib }:

stdenv.mkDerivation rec {
  pname = "sumo";
<<<<<<< HEAD
  version = "1.18.0";
=======
  version = "1.17.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "sumo";
    rev = "v${lib.replaceStrings ["."] ["_"] version}";
<<<<<<< HEAD
    sha256 = "sha256-/MKhec4nhz6juTCc5dNrrDAlzldodGjili4vWkzafPM=";
=======
    sha256 = "sha256-Br5ugEyGu3zLeylCvoVE92zOCpB5cuXLv1dGLpM3FwI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

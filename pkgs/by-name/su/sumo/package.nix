{
  lib,
  bzip2,
  cmake,
  eigen,
  fetchFromGitHub,
  ffmpeg,
  fox_1_6,
  gdal,
  git,
  gl2ps,
  gpp,
  gtest,
  jdk,
  libGL,
  libGLU,
  libX11,
  libjpeg,
  libpng,
  libtiff,
  libxcrypt,
  openscenegraph,
  proj,
  python3,
  python3Packages,
  stdenv,
  swig,
  xercesc,
  xorg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "sumo";
<<<<<<< HEAD
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "eclipse-sumo";
    repo = "sumo";
    tag = "v${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-rUa5DpoBfnviSEmzPEiVnZU0KGavAIOFoysQ74uTll0=";
=======
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "sumo";
    tag = "v${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-xf7/hUJpl+XmXx5MmFzYu2geFNe7JVaxDrraoqLrSuk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  ]
  ++ (with xorg; [
    libX11
    libXcursor
    libXext
    libXfixes
    libXft
    libXrandr
    libXrender
  ]);

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "SUMO traffic simulator";
    longDescription = ''
      Eclipse SUMO is an open source, highly
      portable, microscopic and continuous traffic simulation package
      designed to handle large networks. It allows for intermodal
      simulation including pedestrians and comes with a large set of
      tools for scenario creation.
    '';
    homepage = "https://github.com/eclipse/sumo";
<<<<<<< HEAD
    license = lib.licenses.epl20;
    maintainers = [ ];
    teams = [ lib.teams.geospatial ];
=======
    license = licenses.epl20;
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

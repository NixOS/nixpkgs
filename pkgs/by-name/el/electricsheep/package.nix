{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxGTK32,
  ffmpeg,
  lua5_1,
  curl,
  libpng,
  xorg,
  pkg-config,
  flam3,
  libgtop,
  boost,
  tinyxml,
  libglut,
  libGLU,
  libGL,
  glee,
}:

stdenv.mkDerivation {
  pname = "electricsheep";
  version = "3.0.2-unstable-2024-02-13";

  src = fetchFromGitHub {
    owner = "scottdraves";
    repo = "electricsheep";
    rev = "5fbbb684752be06ccbea41639968aa7f1cc678dd";
    hash = "sha256-X3EZ1/VcLEU1GkZbskWSsqQWYTnsH3pbFDvDLpdLmcU=";
  };

  patches = [
    # <https://github.com/scottdraves/electricsheep/pull/126>
    ./boost-1.85.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    wxGTK32
    ffmpeg
    lua5_1
    curl
    libpng
    xorg.libXrender
    flam3
    libgtop
    boost
    tinyxml
    libglut
    libGLU
    libGL
    glee
  ];

  preAutoreconf = ''
    cd client_generic
    sed -i '/ACX_PTHREAD/d' configure.ac
  '';

  configureFlags = [
    "CPPFLAGS=-I${glee}/include/GL"
  ];

  makeFlags = [
    ''CXXFLAGS+="-DGL_GLEXT_PROTOTYPES"''
  ];

  preBuild = ''
    sed -i "s|/usr|$out|" Makefile
  '';

  meta = with lib; {
    description = "Electric Sheep, a distributed screen saver for evolving artificial organisms";
    homepage = "https://electricsheep.org/";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}

{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, which
, zip
, wxGTK
, gtk3
, sfml
, fluidsynth
, curl
, freeimage
, ftgl
, glew
, lua
, mpg123
}:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "unstable-2022-08-15";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "1a0d25eec54f9ca2eb3667676d93fb0b6b6aea26";
    sha256 = "sha256-mtaJr4HJbp2UnzwaLq12V69DqPYDmSNqMGiuPpMlznI=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-msse/d' src/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    zip
  ];

  buildInputs = [
    wxGTK
    gtk3
    sfml
    fluidsynth
    curl
    freeimage
    ftgl
    glew
    lua
    mpg123
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxGTK}/lib"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ertes ];
  };
}

{ lib
, stdenv
, fetchFromGitLab
, boost
, freefont_ttf
, fribidi
, gettext
, imagemagick
, libpng
, lua
, pkg-config
, povray
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "domino-chain";
  version = "1.1";

  src = fetchFromGitLab {
    owner = "domino-chain";
    repo = "domino-chain.gitlab.io";
    rev = finalAttrs.version;
    hash = "sha256-ERR5QwQpTFLeAijlGtGU0Lpd40II/L5i3muYDN2EfX4=";
  };

  nativeBuildInputs = [
    gettext
    imagemagick
    pkg-config
    povray
  ];

  buildInputs = [
    boost
    freefont_ttf
    fribidi
    libpng
    lua
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    zlib
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-warn /usr/share/fonts/truetype/freefont/ ${freefont_ttf}/share/fonts/truetype/
    substituteInPlace src/domino-chain/screen.cpp \
      --replace-fail /usr/share/fonts/truetype/freefont/ ${freefont_ttf}/share/fonts/truetype/
  '';

  enableParallelBuilding = true;

  __structuredAttrs = true;
  makeFlags = [
    "PREFIX=$(out)"
    "POVRAY=povray Work_Threads=$(NIX_BUILD_CORES)"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL2}/include/SDL2"
    "-I${lib.getDev SDL2_mixer}/include/SDL2"
  ];

  meta = with lib; {
    description = "Rearrange dominoes on different platforms to start a chain reaction. https://domino-chain.gitlab.io";
    homepage = "https://domino-chain.gitlab.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "domino-chain";
    platforms = platforms.all;
  };
})

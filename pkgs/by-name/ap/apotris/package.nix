{
  lib,
  stdenv,
  fetchFromGitea,
  meson,
  libGLU,
  ninja,
  python3,
  cmake,
  pkg-config,
  xxd,
  libopus,
  libogg,
  zlib,
  SDL2,
  SDL2_mixer,
  libopenmpt,
  libXrandr,
  libXext,
  libXfixes,
  libXcursor,
  libXi,
  libXScrnSaver,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apotris";
  version = "4.1.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "akouzoukos";
    repo = "apotris";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jP0fmfAAjWkgI5I3OTLS5+7+xLvcGhV8yP80qDWDjC8=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs tools/bin2s.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    python3
    cmake
    pkg-config
    xxd
  ];

  buildInputs = [
    libGLU
    libopus
    libogg
    zlib
    SDL2_mixer
    libopenmpt
    SDL2
    libXrandr
    libXext
    libXfixes
    libXcursor
    libXi
    libXScrnSaver
  ];

  strictDeps = true;

  dontUseCmakeConfigure = true;

  desktopItem = makeDesktopItem {
    name = "Apotris";
    exec = "Apotris";
    comment = "A block stacking game";
    desktopName = "Apotris";
    categories = [
      "Game"
    ];
  };

  meta = {
    description = "Block stacking game";
    longDescription = ''
      Apotris is a multiplatform open-source block stacking game! What sets
      Apotris apart from other block stacking games is its extensive
      customization options, complemented by ultra-responsive controls that let
      you execute your moves with precision. With 14 unique game modes and a
      plethora of settings, you can tailor the game to your preferences,
      ensuring a fresh and challenging experience every time you play. Whether
      you're a casual player or a hardcore enthusiast, Apotris has something for
      everyone. You can even battle your friends using the Gameboy Advance Link
      Cable or Wireless Adapters in 2-Player Battle! While Apotris was
      originally designed for Gameboy Advance, it now supports all kinds of
      platforms, so between the ports and emulation you can play Apotris on
      almost anything.
    '';
    homepage = "https://akouzoukos.com/apotris/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      oluceps
      bizmyth
    ];
    mainProgram = "Apotris";
    inherit (SDL2.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})

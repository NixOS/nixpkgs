{
  lib,
  stdenv,
  fetchFromGitLab,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  boost,
  cmake,
  curl,
  libx11,
  nix-update-script,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "commandergenius";
  version = "3.6.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    owner = "Dringgstein";
    repo = "Commander-Genius";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pjSWAr3qYLWEwwu/ocXbB1smfPsJ7NAtbForPHenN9Q=";
  };

  postPatch = ''
    export NIX_CFLAGS_COMPILE+=" $(${lib.getDev SDL2}/bin/sdl2-config --cflags)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    boost
    curl
    libx11
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "APPDIR" "bin")
    (lib.cmakeFeature "SHAREDIR" "${placeholder "out"}/share")
  ];

  postInstall = ''
    for icon in $out/share/icons/hicolor/*/apps/cg.*.png; do
      mv "$icon" "$(dirname "$icon")/cg.png"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern Interpreter for the Commander Keen Games";
    longDescription = ''
      Commander Genius is an open-source clone of
      Commander Keen which allows you to play
      the games, and some of the mods
      made for it. All of the original data files
      are required to do so
    '';
    homepage = "https://clonekeenplus.sourceforge.io/";
    changelog = "https://gitlab.com/Dringgstein/Commander-Genius/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hce ];
    platforms = lib.platforms.linux;
    mainProgram = "CGeniusExe";
  };
})

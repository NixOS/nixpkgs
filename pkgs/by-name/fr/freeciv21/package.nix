{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gettext,
  readline,
  python3,
  lua5_3,
  sqlite,
  SDL2_mixer,
  libertinus,
  qt6,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeciv21";
  version = "3.2-dev.3";
  src = fetchFromGitHub {
    owner = "longturn";
    repo = "freeciv21";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n6NLf1EtCpPV+29TvcNk+Hl+UyjM7NHwdBaMLPq7IfY=";
  };
  strictDeps = true;
  __structuredAttrs = true;
  nativeBuildInputs = [
    cmake
    ninja
    python3
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    gettext
    readline
    lua5_3
    sqlite
    SDL2_mixer
    libertinus
    qt6.qtbase
    qt6.qtsvg
    qt6.qtmultimedia
    kdePackages.karchive
  ];
  configurePhase = ''
    runHook preConfigure
    cmake -B build -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DFREECIV_DOWNLOAD_FONTS=0 \
      -DCMAKE_INSTALL_PREFIX=$out
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    cmake --build build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    cmake --install build
    ln -s ${libertinus}/share/fonts $out/share
    runHook postInstall
  '';
  meta = {
    description = "Empire-building strategy game";
    longDescription = ''
      Freeciv21 is a turn-based, empire-building strategy game in which
      each player becomes the leader of a civilization. You build
      cities, develop infrastructure, wage wars, and more, thereby
      competing or collaborating with leaders of other nations. The game
      begins at the dawn of history and stretches into the space age.

      Freeciv21 is rooted in the well-known game Freeciv and extends it
      for more fun, with a revived focus on competitive multiplayer
      environments. Players can choose from over 500 nations and can
      play against the computer or against other people in an active
      online community.
    '';
    homepage = "https://github.com/longturn/freeciv21";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jeltsch ];
    mainProgram = "freeciv21-client";
  };
})

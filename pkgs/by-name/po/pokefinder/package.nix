{
  lib,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,
  fetchFromGitHub,
  cmake,
  python3,
  qt6,
  iconConvTools,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pokefinder";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "Admiral-Fish";
    repo = "PokeFinder";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tItPvA0f2HnY7SUSnb7A5jGwbRs7eQoS4vibBomZ9pw=";
    fetchSubmodules = true;
  };

  patches = [
    ./set-desktop-file-name.patch
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/Applications
    cp -R PokeFinder.app $out/Applications
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    install -D PokeFinder $out/bin/PokeFinder
    icoFileToHiColorTheme $src/Form/Images/pokefinder.ico pokefinder $out
  ''
  + ''
    runHook postInstall
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    (python3.withPackages (ps: [ ps.zstandard ]))
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
    iconConvTools
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "pokefinder";
      exec = "PokeFinder";
      icon = "pokefinder";
      comment = "Cross platform Pokémon RNG tool";
      desktopName = "PokéFinder";
      categories = [ "Utility" ];
    })
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://github.com/Admiral-Fish/PokeFinder";
    description = "Cross platform Pokémon RNG tool";
    mainProgram = "PokeFinder";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ leo60228 ];
  };
})

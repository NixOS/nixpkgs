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
  nlohmann_json,
  zstd,
  gitUpdater,
}:

let
  # Upstream downloads the moving "current" release, built from this commit
  gf2-src = fetchFromGitHub {
    owner = "nessan";
    repo = "gf2";
    rev = "0b09e44fd2c6615a6a1958c480650e207703b84c";
    hash = "sha256-stxWvAEM1NRSD84AL6R8ruHZ0BzqJTn07souA0Y24Nc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pokefinder";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "Admiral-Fish";
    repo = "PokeFinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SPU+p49I6ts6D+pokQ/FAj2YD6t65jrGa/LSQFko8Vo=";
    fetchSubmodules = true;
  };

  patches = [
    ./set-desktop-file-name.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64")' ""
    substituteInPlace Core/CMakeLists.txt \
      --replace-fail 'if (APPLE)' 'if (FALSE)'
    # target("sha") is an x86 extension; GCC rejects it on aarch64
    substituteInPlace Core/RNG/SHA1.cpp \
      --replace-fail '#if defined(__GNUC__) || defined(__clang__)' \
        '#if (defined(__GNUC__) || defined(__clang__)) && (defined(__i386__) || defined(__x86_64__))'
  '';

  # Dependencies upstream downloads with FetchContent
  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GF2" "${gf2-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZSTD" "${zstd.src}")
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isAarch "-flax-vector-conversions";

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
    python3
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

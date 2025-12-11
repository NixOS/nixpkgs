{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  testers,
  opensupaplex,
  SDL2,
  SDL2_mixer,
  desktopToDarwinBundle,
}:

let
  # Doesn't seem to be included in tagged releases, but does exist on master.
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/sergiou87/open-supaplex/b102548699cf16910b59559f689ecfad88d2a7d2/open-supaplex.svg";
    sha256 = "sha256-nKeSBUGjSulbEP7xxc6smsfCRjyc/xsLykH0o3Rq5wo=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opensupaplex";
  version = "7.1.2";

  src = fetchFromGitHub {
    owner = "sergiou87";
    repo = "open-supaplex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hP8dJlLXE5J/oxPhRkrrBl1Y5e9MYbJKi8OApFM3+GU=";
  };

  patches = [
    ./reproducible-build.patch
    ./darwin.patch
  ];

  nativeBuildInputs = [
    SDL2 # For "sdl2-config"
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [ SDL2_mixer ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-DFILE_DATA_PATH=${placeholder "out"}/lib/opensupaplex"
    "-DFILE_FHS_XDG_DIRS"
  ];

  preBuild = ''
    # Makefile is located in this directory
    pushd linux
  '';

  postBuild = ''
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,share/icons/hicolor/scalable/apps}

    install -D ./linux/opensupaplex $out/bin/opensupaplex
    cp -R ./resources $out/lib/opensupaplex
    cp ${icon} $out/share/icons/hicolor/scalable/apps/open-supaplex.svg

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = opensupaplex;
    command = "opensupaplex --help";
    version = "v${finalAttrs.version}";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "opensupaplex";
      exec = finalAttrs.meta.mainProgram;
      icon = "open-supaplex";
      desktopName = "OpenSupaplex";
      comment = finalAttrs.meta.description;
      categories = [
        "Game"
      ];
    })
  ];

  # Strip only the main binary, not the data files which would corrupt them.
  stripExclude = [ "lib/opensupaplex/*" ];

  meta = {
    description = "Decompilation of Supaplex in C and SDL";
    homepage = "https://github.com/sergiou87/open-supaplex";
    changelog = "https://github.com/sergiou87/open-supaplex/blob/master/changelog/v${finalAttrs.version}.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "opensupaplex";
  };
})

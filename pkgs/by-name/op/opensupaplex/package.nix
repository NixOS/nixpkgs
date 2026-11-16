{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  opensupaplex,
  SDL2,
  SDL2_mixer,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensupaplex";
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "sergiou87";
    repo = "open-supaplex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4q4li0TT/tZkrreRFIVCth9Db6eCKORe2HMK2ETO/CY=";
  };

  patches = [
    ./reproducible-build.patch
    ./darwin.patch
  ];

  nativeBuildInputs = [
    SDL2 # For "sdl2-config"
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

    install -Dm755 linux/opensupaplex -t $out/bin
    mkdir -p $out/lib
    cp -R resources $out/lib/opensupaplex
    install -Dm644 linux/assets/io.github.sergiou87.open-supaplex.desktop -t $out/share/applications
    install -Dm644 linux/assets/io.github.sergiou87.open-supaplex.metainfo.xml -t $out/share/metainfo
    install -Dm644 linux/assets/io.github.sergiou87.open-supaplex.svg -t $out/share/icons/hicolor/scalable/apps

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = opensupaplex;
    command = "opensupaplex --help";
    version = "v${finalAttrs.version}";
  };

  # Strip only the main binary, not the data files which would corrupt them.
  stripExclude = [ "lib/opensupaplex/*" ];

  meta = {
    description = "Decompilation of Supaplex in C and SDL";
    homepage = "https://github.com/sergiou87/open-supaplex";
    changelog = "https://github.com/sergiou87/open-supaplex/blob/master/changelog/v${finalAttrs.version}.txt";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "opensupaplex";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_mixer,
  desktopToDarwinBundle,
  nix-update-script,
  ruby,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensupaplex";
  version = "7.2.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "sergiou87";
    repo = "open-supaplex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4q4li0TT/tZkrreRFIVCth9Db6eCKORe2HMK2ETO/CY=";
  };

  patches = [
    # LC_UUID is non-deterministic on Darwin
    ./reproducible-build.patch
    # nixpkgs SDL2_mixer has no framework layout
    ./darwin.patch
  ];

  nativeBuildInputs = [
    SDL2 # For "sdl2-config"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [ SDL2_mixer ];

  makeFlags = [
    "-C"
    "linux"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-DFILE_DATA_PATH=${placeholder "out"}/lib/opensupaplex"
    "-DFILE_FHS_XDG_DIRS"
  ];

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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  enableParallelBuilding = true;
  # Strip only the main binary, not the data files which would corrupt them.
  stripExclude = [ "lib/opensupaplex/*" ];

  versionCheckProgramArg = "--help";

  passthru = {
    tests.demos =
      runCommand "opensupaplex-demos"
        {
          env = {
            SDL_AUDIODRIVER = "dummy";
            SDL_VIDEODRIVER = "dummy";
          };
          nativeBuildInputs = [
            ruby
            writableTmpDirAsHomeHook
          ];
        }
        ''
          cd ${finalAttrs.src}/tests
          ruby run-tests.rb ${lib.getExe finalAttrs.finalPackage}
          touch $out
        '';
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Decompilation of Supaplex in C and SDL";
    homepage = "https://github.com/sergiou87/open-supaplex";
    changelog = "https://github.com/sergiou87/open-supaplex/blob/master/changelog/v${finalAttrs.version}.txt";
    license =
      with lib.licenses;
      AND [
        gpl3Only
        mit
      ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "opensupaplex";
  };
})

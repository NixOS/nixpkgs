{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  copyDesktopItems,
  icoutils,
  makeDesktopItem,
  nix-update-script,
  openal,
  sdl2-compat,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bstone";
  version = "1.3.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bibendovsky";
    repo = "bstone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8ifvHNf+vUtoffxghMwFXpGuarMEEBF+bkSbE4M9zf0=";
  };

  # dlopen'd
  # test segfaults
  postPatch = ''
    substituteInPlace src/bstone/src/bstone_oal_audio_mixer.cpp \
      --replace-fail '"libopenal.so"' '"${lib.getLib openal}/lib/libopenal${stdenv.hostPlatform.extensions.sharedLibrary}"'
    substituteInPlace src/tests/src/tests/src/bstone_tests_memory.cpp \
      --replace-fail 'register_destroy_at();' ""
  '';

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    icoutils
  ];

  buildInputs = [
    openal
    sdl2-compat
  ];

  cmakeFlags = [ (lib.cmakeBool "BSTONE_TESTS" finalAttrs.finalPackage.doCheck) ];

  doCheck = true;
  # process::open_file_or_url test
  nativeCheckInputs = [ xdg-utils ];

  checkPhase = ''
    runHook preCheck
    cmake --install . --prefix "$NIX_BUILD_TOP/tests"
    pushd "$NIX_BUILD_TOP/tests/bstone_tests"
    ./bstone_tests
    popd
    runHook postCheck
  '';

  postInstall = ''
    rm -rf $out/bstone_tests
    mkdir -p $out/{bin,share/doc/bstone}
    mv $out/bstone $out/bin
    mv $out/*.txt $out/share/doc/bstone

    icotool -x $src/src/bstone/src/resources/win32/bstone_icon.ico
    for f in bstone_icon_*.png; do
      res=$(basename "$f" .png | cut -d_ -f4 | cut -dx -f1-2)
      install -Dm644 "$f" "$out/share/icons/hicolor/$res/apps/bstone.png"
    done
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "bstone";
      categories = [
        "Game"
        "ActionGame"
      ];
      comment = finalAttrs.meta.description;
      desktopName = "BStone";
      exec = "bstone";
      icon = "bstone";
    })
  ];

  preVersionCheck = ''
    export SDL_VIDEODRIVER=dummy
  '';

  versionCheckKeepEnvironment = "HOME SDL_VIDEODRIVER";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial source port for the Blake Stone series";
    homepage = "https://bibendovsky.github.io/bstone";
    changelog = "https://github.com/bibendovsky/bstone/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license =
      with lib.licenses;
      AND [
        gpl2Plus
        mit
      ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "bstone";
  };
})

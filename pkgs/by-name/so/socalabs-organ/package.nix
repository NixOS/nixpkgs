{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  ninja,
  pkg-config,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  makeDesktopItem,
  libx11,
  libxrandr,
  libxcursor,
  libxinerama,
  libxext,
  freetype,
  fontconfig,
  expat,
  alsa-lib,
  curl,

  buildStandalone ? true,
  buildVST3 ? true,
  buildLV2 ? true,
}:

let
  cmakeFormats = [
    (lib.optionalString buildStandalone "Standalone")
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "socalabs-organ";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "Organ";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YLgkgpAsaV29qZ7YeGHZXhn5AqTDSwC5mobD0HT0Y3o=";
    fetchSubmodules = true;

    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

  patches = [
    ./fix-strcasecmp.diff
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "FORMATS Standalone VST VST3 AU LV2" "FORMATS ${lib.concatStringsSep " " cmakeFormats}"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    writableTmpDirAsHomeHook
    copyDesktopItems
  ];

  buildInputs = [
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxext
    freetype
    fontconfig
    expat
    alsa-lib
    curl
  ];

  cmakeFlags = [
    "--preset ninja-gcc"
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = "cd ../Builds/ninja-gcc";

  installPhase = ''
    runHook preInstall

    pushd Organ_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/Organ -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/Organ.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/Organ.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  # JUCE dlopens these at runtime, standalone executable crashes without them
  NIX_LDFLAGS = [ "-lX11" ];

  passthru.updateScript = nix-update-script { };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-organ";
      desktopName = "Socalabs Organ";
      comment = "Socalabs Electric Organ Emulation Plugin (Standalone)";
      exec = "Organ";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    description = "Electric organ emulation based on setBfree";
    homepage = "https://socalabs.com/synths/organ";
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "Organ";
  };
})

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
  libxinerama,
  libxext,
  libxcursor,
  expat,
  freetype,
  fontconfig,
  curl,
  alsa-lib,

  buildStandalone ? false, # TODO: `__structuredAttrs` breaks standalone
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
  name = "socalabs-piano";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "piano";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/tikuRtigVNgAzCkG+4HOrOvh/SJFl7DHY3dovzoC88=";
    fetchSubmodules = true;

    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

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

  __structuredAttrs = true;
  strictDeps = true;

  cmakeFlags = [
    "--preset ninja-gcc"
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)

    (lib.cmakeFeature "CMAKE_EXE_LINKER_FLAGS" "-L${lib.getLib curl}/lib")
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = "cd ../Builds/ninja-gcc";

  installPhase = ''
    runHook preInstall

    pushd Piano_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/Piano -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/Piano.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/Piano.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  desktopItems = lib.optional buildStandalone (makeDesktopItem {
    type = "Application";
    name = "socalabs-piano";
    desktopName = "Socalabs Piano";
    comment = "Socalabs Piano Plugin (Standalone)";
    exec = "Piano";
    categories = [
      "Audio"
      "AudioVideo"
    ];
  });

  meta = {
    description = "Digital waveguide piano physical model with VST and command line interface";
    homepage = "https://socalabs.com/synths/piano/";
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "Piano";
  };
})

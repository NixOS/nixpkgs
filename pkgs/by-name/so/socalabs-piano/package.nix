{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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

  buildStandalone ? true,
  buildVST3 ? true,
  buildLV2 ? false, # TODO: broken
}:

let
  cmakeFormats = [
    (lib.optionalString buildStandalone "Standalone")
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
  ];
in

stdenv.mkDerivation {
  name = "socalabs-piano";
  version = "0-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "piano";
    rev = "25a21387a6395cfb23bf97fed3a4b5cd92da315d";
    hash = "sha256-M7cW8xBG9fl3v5WagzqcasMoQt8Pic4RMj2bfwUYrOs=";
    fetchSubmodules = true;

    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

  patches = [
    # Fixes audio glitches
    (fetchpatch {
      url = "https://github.com/FigBug/Piano/pull/7.patch";
      hash = "sha256-9Kqh22yD0ehvCUTo1/gieOQ1M3jpRSoOK+Rn3xWaWjM=";
    })
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

  # Needed by standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  passthru.updateScript = nix-update-script { };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-piano";
      desktopName = "Socalabs Piano";
      comment = "Socalabs Piano Plugin (Standalone)";
      exec = "Piano";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    description = "Digital waveguide piano physical model with VST and command line interface";
    homepage = "https://socalabs.com/synths/piano";
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "Piano";
  };
}

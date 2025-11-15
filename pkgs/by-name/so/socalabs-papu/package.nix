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
  libxcursor,
  libxrandr,
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

stdenv.mkDerivation {
  pname = "socalabs-papu";
  version = "0-unstable-2025-08-08";

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "papu";
    rev = "a97cbf33c5c62648903d8d344602079ab81a52dd";
    hash = "sha256-8TSMWHxTcbgKTuXGLdYL/FyHzajgOLA7Gh90I+6eApc=";
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

  cmakeFlags = [
    "--preset ninja-gcc"
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = "cd ../Builds/ninja-gcc";

  installPhase = ''
    runHook preInstall

    pushd PAPU_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/PAPU -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/PAPU.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/PAPU.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  # Needed for standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  passthru.updateScript = nix-update-script { };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-papu";
      desktopName = "Socalabs PAPU";
      comment = "Socalabs Nintendo Gameboy PAPU Emulation Plugin (Standalone)";
      exec = "PAPU";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    description = "Nintendo Gameboy PAPU emulation";
    homepage = "https://socalabs.com/synths/papu";
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "PAPU";
  };
}

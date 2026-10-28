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
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  expat,
  freetype,
  fontconfig,
  curl,
  alsa-lib,
  buildStandalone ? false, # TODO: `__structuredAttrs` breaks standalone
  buildVST3 ? true,
  buildLV2 ? true,
  buildCLAP ? true,
}:
let
  cmakeFormats = [
    (lib.optionalString buildStandalone "Standalone")
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "socalabs-piano";
  version = "1.0.14";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FigBug";
    repo = "piano";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cx2yWGxU8u7SOklRCogdgMsAeIsRlAnOkjp5l7S/keY=";
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
  ''
  + lib.optionalString (!buildCLAP) ''
    # CLAP is not part of juce_add_plugin's FORMATS; it is added by a separate
    # clap_juce_extensions_plugin call. Shadow that with a no-op function
    # rather than trying to delete the multi-line call itself.
    substituteInPlace CMakeLists.txt \
      --replace-fail "clap_juce_extensions_plugin (TARGET" \
    "function (clap_juce_extensions_plugin)
    endfunction ()
    clap_juce_extensions_plugin (TARGET"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    writableTmpDirAsHomeHook
  ]
  ++ lib.optional buildStandalone copyDesktopItems;

  buildInputs = [
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    expat
    freetype
    fontconfig
    alsa-lib
    curl
  ];

  cmakeFlags = [
    "--preset ninja-gcc"
    (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
    (lib.cmakeFeature "CMAKE_EXE_LINKER_FLAGS" "-L${lib.getLib curl}/lib")
  ];

  # JUCE dlopens these rather than linking them, so nothing lands in the
  # RUNPATH otherwise. -lXi is essential: JUCE requests the unversioned
  # "libXi.so", which no host has already loaded, and when that dlopen fails
  # JUCE still believes XInput2 is present (the stub for the missing
  # XIQueryVersion returns 0, which equals Success), so it discards all core
  # pointer events and the GUI stops responding to the mouse entirely.
  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-lXcursor"
    "-lXext"
    "-lXi"
    "-lXinerama"
    "-lXrandr"
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
      ${lib.optionalString buildCLAP ''
        install -Dm755 CLAP/Piano.clap -t $out/lib/clap
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
    description = "Digital waveguide piano physical model as a VST3, LV2 and CLAP plugin";
    homepage = "https://socalabs.com/synths/piano/";
    platforms = [ "x86_64-linux" ];
    # COPYING is GPL-2, the README says GPL-3.0; the bundled JUCE is
    # AGPLv3-or-commercial and is statically linked into the plugin.
    license = with lib.licenses; [
      gpl3Only
      agpl3Only
    ];
    maintainers = with lib.maintainers; [
      mrtnvgr
      magnetophon
    ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "Piano";
  };
})

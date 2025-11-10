{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
  alsa-lib,
  expat,
  fontconfig,
  freetype,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,

  buildStandalone ? true,
  buildVST3 ? true,
  buildLV2 ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "filtr";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "filtr";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-LRVwJ/Eh+XeNGnlbd2c56hWV8StHZGhxy0XLjGZ0toY=";
  };

  patches = [
    # Adds BUILD_VST3, BUILD_LV2 cmake flags
    # TODO: remove on update (merged upstream)
    (fetchpatch {
      url = "https://github.com/tiagolr/filtr/pull/6.diff";
      hash = "sha256-fijZrT8rPX14OCv6yxZC//NurexFoq8I2BJ8rldWJZU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    alsa-lib
    expat
    fontconfig
    freetype
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  # Needed by standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "juce::juce_recommended_lto_flags" "# Not forcing LTO"

    substituteInPlace CMakeLists.txt \
      --replace-fail "COPY_PLUGIN_AFTER_BUILD TRUE" "COPY_PLUGIN_AFTER_BUILD FALSE"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_AR" (lib.getExe' stdenv.cc.cc "gcc-ar"))
    (lib.cmakeFeature "CMAKE_RANLIB" (lib.getExe' stdenv.cc.cc "gcc-ranlib"))

    (lib.cmakeBool "BUILD_STANDALONE" buildStandalone)
    (lib.cmakeBool "BUILD_VST3" buildVST3)
    (lib.cmakeBool "BUILD_LV2" buildLV2)
  ];

  installPhase = ''
    runHook preInstall

    pushd FILTR_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/FILT-R -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/FILT-R.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/FILT-R.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Envelope based filter modulator";
    homepage = "https://github.com/tiagolr/filtr";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "FILT-R";
  };
})

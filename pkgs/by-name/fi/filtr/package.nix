{
  stdenv,
  lib,
  fetchFromGitHub,
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

  # JUCE dlopens these at runtime, standalone executable crashes without them
  NIX_LDFLAGS = [
    "-lX11"
    "-lXext"
    "-lXcomposite"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-lXrender"
    "-lXtst"
    "-lXdmcp"
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
  ];

  installPhase = ''
    runHook preInstall

    pushd FILTR_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/FILT-R -t $out/bin
      ''}

      mkdir -p $out/lib/{vst3,lv2}
      cp -r VST3/FILT-R.vst3 $out/lib/vst3
      cp -r LV2/FILT-R.lv2 $out/lib/lv2
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
    mainProgram = lib.optionalString buildStandalone "FILT-R";
  };
})

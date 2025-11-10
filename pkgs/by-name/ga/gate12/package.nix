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
  buildVST3 ? true,
  buildLV2 ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gate12";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "gate12";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-2b58XzuV2wcO8/JAlC628Cz+ZWTKEGTzpIAicMrXanc=";
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

    pushd GATE12_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/GATE-12 -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/GATE-12.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/GATE-12.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Envelope generator for gate/volume control";
    homepage = "https://github.com/tiagolr/gate12";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "GATE-12";
  };
})

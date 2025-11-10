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
  name = "reevr";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "reevr";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ONzh3fDaMdRm5uAGZjYzAuQp9bEAhMfG5lhs0/awvl0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    alsa-lib
  ];

  # Needed for standalone
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

    pushd REEVR_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/REEV-R -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/REEV-R.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/REEV-R.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convolution reverb with pre and post modulation";
    homepage = "https://github.com/tiagolr/reevr";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "REEV-R";
  };
})

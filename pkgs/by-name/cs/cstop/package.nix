{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  cmake,
  pkg-config,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  freetype,
  fontconfig,
  expat,
  alsa-lib,
  juce,

  buildStandalone ? true,
  buildVST3 ? true,
  buildCLAP ? true,
}:

let
  chowdsp_utils = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = "chowdsp_utils";
    tag = "v2.3.0";
    hash = "sha256-/RCbCQ302lsXDgyQ4AmQJqPmky+CvvjZbj6NdboNPbM=";
  };

  clap-juce-extensions = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "645ed2fd0949d36639e3d63333f26136df6df769";
    hash = "sha256-Lx88nyEFjPLA5yh8rrqBdyZIxe/j0FgIHoyKcbjuuI4=";
    fetchSubmodules = true;
  };
in

stdenv.mkDerivation (finalAttrs: {
  name = "cstop";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "calgoheen";
    repo = "cStop";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-TzXsT1rKHu62O+NB6xvTLsoBwP3B8UmCOQaH+kqSQDI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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
  ];

  # Needed for standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  patches = [
    # Adds CMake BUILD_* options
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/calgoheen/cStop/pull/5.patch";
      hash = "sha256-jkjOLVEVA3n1xOcFmgy5FIICaLOSU5VNvyIASZzklkc=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "juce::juce_recommended_lto_flags" "# Not forcing LTO"

    substituteInPlace CMakeLists.txt \
      --replace-fail "COPY_PLUGIN_AFTER_BUILD TRUE" "COPY_PLUGIN_AFTER_BUILD FALSE"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_AR" (lib.getExe' stdenv.cc.cc "gcc-ar"))
    (lib.cmakeFeature "CMAKE_RANLIB" (lib.getExe' stdenv.cc.cc "gcc-ranlib"))

    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JUCE" "${juce.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CLAP-JUCE-EXTENSIONS" "${clap-juce-extensions}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CHOWDSP_UTILS" "${chowdsp_utils}")

    (lib.cmakeBool "BUILD_STANDALONE" buildStandalone)
    (lib.cmakeBool "BUILD_VST3" buildVST3)
    (lib.cmakeBool "BUILD_CLAP" buildCLAP)
  ];

  installPhase = ''
    runHook preInstall

    pushd cStop_artefacts/Release
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/cStop -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/cStop.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildCLAP ''
        mkdir -p $out/lib/clap
        cp CLAP/cStop.clap $out/lib/clap
      ''}
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tape stop audio effect plugin";
    homepage = "https://github.com/calgoheen/cStop";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "cStop";
  };
})

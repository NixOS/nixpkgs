{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lib,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
  nix-update-script,
  juce,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  freetype,
  fontconfig,
  alsa-lib,
  expat,

  buildVST3 ? true,
  buildLV2 ? true,
  buildCLAP ? true,
}:

let
  juce-clap-extensions = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "a3227c52fa082d2df33f4377ed1e050dd8a52595"; # LIB_CLAP_TAG from CMakeLists.txt
    hash = "sha256-g32npkz9fQllcFRo3GKnoQ/U17j42GKBAjd4Kf7OGPI=";
    fetchSubmodules = true;
  };

  chowdsp_utils = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = "chowdsp_utils";
    rev = "ffc70ba399f9afaeefb996eb14e55a1d487270b8"; # LIB_CHOWDSP_UTILS_TAG from CMakeLists.txt
    hash = "sha256-rKjrhb+w/lW9k3Dg5jWM2eJRa0fPDF8SNVrCTFrRMoM=";
  };

  # src/dsp/guitarml-byod/CMakeLists.txt
  rtneural = fetchFromGitHub {
    owner = "jatinchowdhury18";
    repo = "RTNeural";
    rev = "04cb333bc4b174760958a77c7ce076eae38fe8e4"; # LIB_RTNEURAL_TAG
    hash = "sha256-kTHYEpoXPYNKEs7rHeSwBHVQnOQKhKnST+UWa++uCsc=";
    fetchSubmodules = true;

    postFetch = ''
      # note: if rtneural is updated, this won't be needed anymore
      substituteInPlace $out/CMakeLists.txt \
        --replace-fail "include(cmake/CPM.cmake)" "# No tests" \

      # Required for CMake 4
      substituteInPlace $out/CMakeLists.txt \
        --replace-fail \
          "cmake_minimum_required(VERSION 3.5)" \
          "cmake_minimum_required(VERSION 4.0)"
    '';
  };

  # src/dsp/guitarml-byod/CMakeLists.txt
  math_approx = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = "math_approx";
    rev = "0c68d4d17242d707ba07fa7f1901692b7ed72d58"; # LIB_CHOWDSP_MATH_APPROX_TAG
    hash = "sha256-t6UrsZGRJjJVp+aGkwBa++Skj9xkdQuZKAxRrTkfM0E=";
  };

  # src/dsp/guitarml-byod/CMakeLists.txt
  ea_variant = fetchFromGitHub {
    owner = "eyalamirmusic";
    repo = "Variant";
    rev = "3fce49cfca50ba3b05026d41ffc4911a8e653378"; # LIB_VARIANT_TAG
    hash = "sha256-2zzam7rKY6zoT2jFqDtr4pwOCAWTu0GTxUqVGxVHbQQ=";
  };

  formats = lib.concatStringsSep " " [
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildLV2 "LV2")
  ];
in
stdenv.mkDerivation (finalAttrs: {
  name = "jc303";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "midilab";
    repo = "jc303";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5OA7ir8loT0Lx05guwuZNCW9J9I3TA5+A9JZ9E7oWXA=";
  };

  patches = [
    # `BUILD_CLAP` cmake flag
    (fetchpatch {
      url = "https://github.com/midilab/jc303/pull/32.diff";
      hash = "sha256-WvLIcSHrLiXj1VEV+IxS05YSWEq7oz57qIbNsqRySaY=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(PLUGIN_FORMATS AU VST3 LV2)" "set(PLUGIN_FORMATS ${formats})" \
      --replace-fail "juce::juce_recommended_lto_flags" "# No lto"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libx11
    libxrandr
    libxext
    libxcursor
    libxinerama
    freetype
    fontconfig
    expat
    alsa-lib
  ];

  cmakeFlags = [
    # CMakeLists.txt
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JUCE" "${juce.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JUCE-CLAP-EXTENSIONS" "${juce-clap-extensions}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CHOWDSP_UTILS" "${chowdsp_utils}")

    # src/dsp/guitarml-byod/CMakeLists.txt
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RTNEURAL" "${rtneural}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MATH_APPROX" "${math_approx}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_EA_VARIANT" "${ea_variant}")

    (lib.cmakeFeature "CMAKE_AR" (lib.getExe' stdenv.cc.cc "gcc-ar"))
    (lib.cmakeFeature "CMAKE_RANLIB" (lib.getExe' stdenv.cc.cc "gcc-ranlib"))

    (lib.cmakeBool "BUILD_CLAP" buildCLAP)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  installPhase = ''
    runHook preInstall

    pushd JC303_artefacts/Release
      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/JC303.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString buildCLAP ''
        mkdir -p $out/lib/clap
        cp -r CLAP/JC303.clap $out/lib/clap
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r LV2/JC303.lv2 $out/lib/lv2
      ''}
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Roland TB-303 clone plugin";
    homepage = "https://github.com/midilab/jc303";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  alsa-lib,
  freetype,
  juce,
  xsimd,

  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quad-morph-filter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "OTODESK4193";
    repo = "QuadMorphFilter";
    tag = "V${finalAttrs.version}";
    hash = "sha256-xz97h8j411r7g6fSVDo8E4ARLyIP++qK26aTvDqP+Yo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # FilterVisualizer writes a per-pixel response curve into a fixed
  # std::array<float,1024>, assuming the editor is <=1024px wide. The standalone
  # window is resizable (HiDPI/large/tiled displays make it far wider), so the
  # write overruns the array and smashes adjacent editor members -> SIGSEGV on the
  # first paint. Clamp the width to the buffer and size the buffer for wide windows.
  # see https://github.com/OTODESK4193/QuadMorphFilter/issues/2
  patches = [ ./filtervisualizer-clamp-width.patch ];

  postPatch = ''
    # Use JUCE from nixpkgs instead of a hardcoded Windows path, and drop
    # -mavx2/-mfma: baseline x86_64-linux has no AVX2 and other platforms
    # reject the flags. The code contains no AVX intrinsics; it compiles
    # and runs fine without them.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(JUCE_DIR "C:/JUCE")' 'find_package(JUCE CONFIG REQUIRED)' \
      --replace-fail 'add_subdirectory(''${JUCE_DIR} build_juce)' "" \
      --replace-fail ' -mavx2 -mfma' "" \
      --replace-fail ' -ffast-math' ""

    # The Linux WebBrowserComponent (gtk3/webkit) and curl are unused by the
    # plugin; disable them instead of pulling the dependencies in.
    printf '\ntarget_compile_definitions(QuadMorphFilter PUBLIC JUCE_WEB_BROWSER=0 JUCE_USE_CURL=0)\n' >> CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    freetype
    juce # propagates fontconfig
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
    xsimd
  ];

  cmakeFlags = [
    # Upstream pulls xsimd via FetchContent; resolve it through
    # find_package against the xsimd in buildInputs instead of the network.
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
  ];

  cmakeBuildType = "RelWithDebInfo";

  # JUCE dlopens these at runtime, standalone executable crashes without them.
  # Must go through `env`: with __structuredAttrs only `env` entries are
  # exported, so a top-level NIX_LDFLAGS never reaches the ld wrapper.
  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ];

  # Upstream has no install rules.
  installPhase = ''
    runHook preInstall

    install -Dm755 "QuadMorphFilter_artefacts/$cmakeBuildType/Standalone/Quad-Morph Filter" \
      "$out/bin/quad-morph-filter"
    mkdir -p "$out/lib/vst3"
    cp -r "QuadMorphFilter_artefacts/$cmakeBuildType/VST3/Quad-Morph Filter.vst3" "$out/lib/vst3/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "V(.*)"
    ];
  };

  meta = {
    description = "Morphing multi-filter audio plugin with 28 filter models controlled from an XY pad";
    homepage = "https://github.com/OTODESK4193/QuadMorphFilter";
    changelog = "https://github.com/OTODESK4193/QuadMorphFilter/releases/tag/V${finalAttrs.version}";
    # Stated in README.md ("GPLv3, inherited via the JUCE framework");
    # the repository ships no LICENSE file.
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "quad-morph-filter";
  };
})

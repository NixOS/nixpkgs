{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  ninja,
  pkg-config,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  libxtst,
  freetype,
  fontconfig,
  webkitgtk_4_1,
  curl,
  alsa-lib,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxdmcp,
  libdeflate,
  lerc,
  xz,
  libwebp,
  libxkbcommon,
  libepoxy,
  sqlite,
  juce,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spectralsuite";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "andrewreeman";
    repo = "SpectralSuite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CqnmF+i7JoAaKQHVx9SwgA566TV0M5BdjibE8ik9AHk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "juce::juce_recommended_lto_flags" "# no lto"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxext
    libxcursor
    libxtst
    freetype
    fontconfig
    webkitgtk_4_1
    curl
    alsa-lib
    libsysprof-capture
    pcre2
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libxdmcp
    libdeflate
    lerc
    xz
    libwebp
    libxkbcommon
    libepoxy
    sqlite
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JUCE" "${juce.src}")
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=float-equal"
    "-Wno-error=overloaded-virtual="
    "-Wno-error=shadow"
    "-Wno-error=catch-value="
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3
    for plugin in BinScrambler FrequencyMagnet FrequencyShift Morph PhaseLock SinusoidalShapedFilter SpectralGate; do
      cp -r $plugin/*_artefacts/Release/VST3/*.vst3 $out/lib/vst3
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of audio plugins for spectral manipulation";
    longDescription = "Collection of audio plugins that utilise the FFT algorithm to manipulate the spectral components of the input audio";
    homepage = "https://github.com/andrewreeman/spectralsuite";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [ lib.licenses.unlicense ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})

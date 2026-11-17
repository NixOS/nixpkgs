{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  juce,
  libspecbleach,
  fftwFloat,
  freetype,
  alsa-lib,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "noise-repellent";
  version = "0.3.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = "noise-repellent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DDURrWUcFaJxOEg8+51caYnYPXZZJhSqTJd9HGvzZ3g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    juce # juceaide
  ];

  buildInputs = [
    juce
    libspecbleach
    fftwFloat
    freetype
    alsa-lib
    libGL
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_JUCE" true)
    (lib.cmakeBool "USE_SYSTEM_FFTW" true)
    (lib.cmakeBool "USE_SYSTEM_FREETYPE" true)
    (lib.cmakeBool "USE_SYSTEM_SPECBLEACH" true)
  ];

  # Upstream's install() rules use generator expressions inside
  # install(DIRECTORY ...), which CMake does not expand, so the install phase
  # looks for a literal "$<GENEX_EVAL:...>" directory and fails.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/lv2 $out/lib/vst3
    cp -r "NoiseRepellent_artefacts/Release/LV2/Noise Repellent.lv2" $out/lib/lv2/
    cp -r "NoiseRepellent_artefacts/Release/VST3/Noise Repellent.vst3" $out/lib/vst3/

    runHook postInstall
  '';

  meta = {
    description = "Audio plugin for broadband noise reduction (LV2, VST3)";
    homepage = "https://github.com/lucianodato/noise-repellent";
    changelog = "https://github.com/lucianodato/noise-repellent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})

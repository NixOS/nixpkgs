{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,

  cmake,
  ninja,

  alsa-lib,
  libjack2,
  libpulseaudio,
  libvorbis,
  opusfile,
  sndio,

  alsaSupport ? true,
  pulseSupport ? true,
  jackSupport ? true,
  sndioSupport ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "miniaudio";
  version = "0.11.23";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
    tag = finalAttrs.version;
    hash = "sha256-ZrfKw5a3AtIER2btCKWhuvygasNaHNf9EURf1Kv96Vc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libvorbis
    opusfile
  ]
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional jackSupport libjack2
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional sndioSupport sndio;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "MINIAUDIO_NO_RUNTIME_LINKING" true)
    (lib.cmakeBool "MINIAUDIO_BUILD_TESTS" true)
    (lib.cmakeBool "MINIAUDIO_BUILD_EXAMPLES" true)

    (lib.cmakeBool "MINIAUDIO_ENABLE_ONLY_SPECIFIC_BACKENDS" true)
    (lib.cmakeBool "MINIAUDIO_ENABLE_PULSEAUDIO" pulseSupport)
    (lib.cmakeBool "MINIAUDIO_ENABLE_JACK" jackSupport)
    (lib.cmakeBool "MINIAUDIO_ENABLE_SNDIO" alsaSupport)
    (lib.cmakeBool "MINIAUDIO_ENABLE_ALSA" sndioSupport)
  ];

  doCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Single header audio playback and capture library written in C";
    homepage = "https://github.com/mackron/miniaudio";
    changelog = "https://github.com/mackron/miniaudio/blob/${finalAttrs.version}/CHANGES.md";
    license = with licenses; [
      unlicense # or
      mit0
    ];
    maintainers = [ maintainers.jansol ];
    pkgConfigModules = [ "miniaudio" ];
    platforms = platforms.linux;
  };
})

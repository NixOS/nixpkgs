{
  lib,
  stdenv,
  fetchFromSourcehut,
  pkg-config,
  libsamplerate,
  libsndfile,
  fftw,
  lv2,
  jdk_headless,
  vamp-plugin-sdk,
  ladspa-header,
  meson,
  ninja,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rubberband";
  version = "4.0.0";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~breakfastquay";
    repo = "rubberband";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TjW+Op750ZzPVD3c/ybyYGM0G65nK5JgMBr/MMsQ8kw=";
  };

  patches = [
    # Fix missing size_t definition when building with libc++ 21.
    # Source: https://github.com/breakfastquay/rubberband/pull/126
    ./0001-Fix-an-error-with-libcxx-21.patch
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isx86_32) [
    jdk_headless
  ];

  buildInputs = [
    libsndfile
    vamp-plugin-sdk
    ladspa-header
    lv2
  ];

  propagatedBuildInputs = [
    libsamplerate
    fftw
  ];

  checkInputs = [
    boost
  ];

  mesonFlags = [
    (lib.mesonEnable "jni" (!stdenv.hostPlatform.isx86_32))
    (lib.mesonEnable "ladspa" true)
    (lib.mesonEnable "lv2" true)
    (lib.mesonEnable "vamp" true)
    (lib.mesonEnable "cmdline" true)
    (lib.mesonOption "fft" "fftw")
    (lib.mesonOption "resampler" "libsamplerate")
    (lib.mesonEnable "tests" finalAttrs.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = "https://breakfastquay.com/rubberband/";
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.jopejoe1 ];
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  fftw,
  libjack2,
  libsamplerate,
  libsndfile,
  pkg-config,
  python311,
  wafHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aubio";
  version = "0.4.9";

  src = fetchurl {
    url = "https://aubio.org/pub/aubio-${finalAttrs.version}.tar.bz2";
    sha256 = "1npks71ljc48w6858l9bq30kaf5nph8z0v61jkfb70xb9np850nl";
  };

  nativeBuildInputs = [
    pkg-config
    python311
    wafHook
  ];
  buildInputs = [
    alsa-lib
    fftw
    libjack2
    libsamplerate
    libsndfile
  ];

  strictDeps = true;
  wafFlags = lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--disable-tests";

  postPatch = ''
    # U was removed in python 3.11 because it had no effect
    substituteInPlace waflib/*.py \
      --replace "m='rU" "m='r" \
      --replace "'rU'" "'r'"
  '';

  meta = {
    description = "Library for audio labelling";
    homepage = "https://aubio.org/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      marcweber
      fpletz
    ];
    platforms = lib.platforms.linux;
  };
})

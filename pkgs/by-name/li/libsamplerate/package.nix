{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsamplerate";
  version = "0.2.2";

  src = fetchurl {
    url = "https://github.com/libsndfile/libsamplerate/releases/download/${finalAttrs.version}/libsamplerate-${finalAttrs.version}.tar.xz";
    hash = "sha256-MljaKAUR0ktJ1rCGFbvoJNDKzJhCsOTK8RxSzysEOJM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  configureFlags = [ "--disable-fftw" ];

  outputs = [
    "dev"
    "out"
  ];

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = "https://libsndfile.github.io/libsamplerate/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.all;
    # Linker is unhappy with the `.def` file.
    broken = stdenv.hostPlatform.isMinGW;
  };
})

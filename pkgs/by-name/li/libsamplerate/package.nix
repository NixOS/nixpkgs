{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "libsamplerate";
  version = "0.2.2";

  src = fetchurl {
    url = "https://github.com/libsndfile/libsamplerate/releases/download/${version}/libsamplerate-${version}.tar.xz";
    hash = "sha256-MljaKAUR0ktJ1rCGFbvoJNDKzJhCsOTK8RxSzysEOJM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  configureFlags = [ "--disable-fftw" ];

  outputs = [
    "dev"
    "out"
  ];

  meta = with lib; {
    description = "Sample Rate Converter for audio";
    homepage = "https://libsndfile.github.io/libsamplerate/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.all;
    # Linker is unhappy with the `.def` file.
    broken = stdenv.hostPlatform.isMinGW;
  };
}

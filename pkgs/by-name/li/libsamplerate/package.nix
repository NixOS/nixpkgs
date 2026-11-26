{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
  testers,
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

  strictDeps = true;

  configureFlags = [ "--disable-fftw" ];

  outputs = [
    "dev"
    "out"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  __structuredAttrs = true;

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = "https://libsndfile.github.io/libsamplerate/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
    # Linker is unhappy with the `.def` file.
    broken = stdenv.hostPlatform.isMinGW;
    pkgConfigModules = [
      "samplerate"
    ];
  };
})

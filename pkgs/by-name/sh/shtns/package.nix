{
  lib,
  stdenv,
  fetchgit,
  fftw,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shtns";
  version = "3.5.1";

  src = fetchgit {
    url = "https://bitbucket.org/nschaeff/shtns";
    rev = "v${finalAttrs.version}";
    sha256 = "1ajrplhv7a2dvb3cn3n638281w0bzdcydvvwbg64awbjg622mdpd";
  };

  buildInputs = [ fftw ];

  meta = {
    description = "High performance library for Spherical Harmonic Transform";
    homepage = "https://nschaeff.bitbucket.io/shtns/";
    license = lib.licenses.cecill21;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
})

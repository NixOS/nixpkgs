{
  lib,
  stdenv,
  fetchgit,
  fftw,
}:

stdenv.mkDerivation rec {
  pname = "shtns";
  version = "3.5.1";

  src = fetchgit {
    url = "https://bitbucket.org/nschaeff/shtns";
    rev = "v${version}";
    sha256 = "1ajrplhv7a2dvb3cn3n638281w0bzdcydvvwbg64awbjg622mdpd";
  };

  buildInputs = [ fftw ];

  meta = with lib; {
    description = "High performance library for Spherical Harmonic Transform";
    homepage = "https://nschaeff.bitbucket.io/shtns/";
    license = licenses.cecill21;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}

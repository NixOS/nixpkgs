{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  freebsd,
}:

stdenv.mkDerivation rec {
  pname = "libipt";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${version}";
    sha256 = "sha256-rO2Mf2/BfKlPh1wHe0qTuyQAyqpSB/j3Q+JWpNDyNm0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.hostPlatform.isFreeBSD freebsd.libstdthreads;

  env = lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
    NIX_LDFLAGS = "-lstdthreads";
  };

  meta = with lib; {
    description = "Intel Processor Trace decoder library";
    homepage = "https://github.com/intel/libipt";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}

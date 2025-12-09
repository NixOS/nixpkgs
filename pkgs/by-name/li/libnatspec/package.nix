{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  popt,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "libnatspec";
  version = "0.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/natspec/${pname}-${version}.tar.bz2";
    sha256 = "0wffxjlc8svilwmrcg3crddpfrpv35mzzjgchf8ygqsvwbrbb3b7";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ popt ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  propagatedBuildInputs = [ libiconv ];

  meta = with lib; {
    homepage = "https://natspec.sourceforge.net/";
    description = "Library intended to smooth national specificities in using of programs";
    mainProgram = "natspec";
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}

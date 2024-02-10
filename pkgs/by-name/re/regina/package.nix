{ lib
, stdenv
, fetchurl
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "regina-rexx";
  version = "3.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/regina-rexx/regina-rexx/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-COmpBhvuADjPtFRG3iB2b/2uUO6jf2ZCRG7E5zoqvFE=";
  };

  buildInputs = [ ncurses ];

  configureFlags = [
    "--libdir=$(out)/lib"
  ];

  meta = with lib; {
    description = "REXX interpreter";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}

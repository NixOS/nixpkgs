{
  lib,
  gccStdenv,
  fetchurl,
  gmp,
}:

gccStdenv.mkDerivation rec {
  pname = "cln";
  version = "1.3.7";

  src = fetchurl {
    url = "${meta.homepage}cln-${version}.tar.bz2";
    sha256 = "sha256-fH7YR0lYM35N9btX6lF2rQNlAEy7mLYhdlvEYGoQ2Gs=";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "C/C++ library for numbers, a part of GiNaC";
    mainProgram = "pi";
    homepage = "https://www.ginac.de/CLN/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix; # Once had cygwin problems
  };
}

{
  lib,
  stdenv,
  fetchurl,
  pari,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "gp2c";
  version = "0.0.13";

  src = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/GP2C/${pname}-${version}.tar.gz";
    hash = "sha256-JhN07Kc+vXbBEqlZPcootkgSqnYlYf2lpLLCzXmmnTY=";
  };

  buildInputs = [
    pari
    perl
  ];

  configureFlags = [
    "--with-paricfg=${pari}/lib/pari/pari.cfg"
    "--with-perl=${perl}/bin/perl"
  ];

  meta = with lib; {
    homepage = "http://pari.math.u-bordeaux.fr/";
    description = "A compiler to translate GP scripts to PARI programs";
    downloadPage = "http://pari.math.u-bordeaux.fr/download.html";
    inherit (pari.meta)
      license
      maintainers
      platforms
      broken
      ;
  };
}

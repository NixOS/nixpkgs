{
  lib,
  stdenv,
  fetchurl,
  pari,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "gp2c";
  version = "0.0.14";

  src = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/GP2C/${pname}-${version}.tar.gz";
    hash = "sha256-r2ESzAKUBFfiOdpEM9Gg2Npg7u8p98xyL2TNSsALezA=";
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
    description = "Compiler to translate GP scripts to PARI programs";
    downloadPage = "http://pari.math.u-bordeaux.fr/download.html";
    inherit (pari.meta)
      license
      maintainers
      teams
      platforms
      broken
      ;
  };
}

{ stdenv, fetchurl, postgresql, makeWrapper }:
stdenv.mkDerivation rec {
  name = "ephemeralpg-${version}";
  version = "2.5";
  src = fetchurl {
    url = "http://ephemeralpg.org/code/${name}.tar.gz";
    sha256 = "004fcll7248h73adkqawn9bhkqj9wsxyi3w99x64f7s37r2518wk";
  };
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    PREFIX=$out make install
    wrapProgram $out/bin/pg_tmp --prefix PATH : ${postgresql}/bin
  '';
  meta = {
    description = ''Run tests on an isolated, temporary PostgreSQL database.'';
    license = stdenv.lib.licenses.isc;
    homepage = http://ephemeralpg.org/;
  };
}

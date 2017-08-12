{ stdenv, fetchurl, postgresql, makeWrapper }:
stdenv.mkDerivation rec {
  name = "ephemeralpg-${version}";
  version = "2.2";
  src = fetchurl {
    url = "http://ephemeralpg.org/code/${name}.tar.gz";
    sha256 = "1v48bcmc23zzqbha80p3spxd5l347qnjzs4z44wl80i2s8fdzlyz";
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

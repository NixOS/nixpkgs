{
  lib,
  stdenv,
  fetchurl,
  postgresql,
  getopt,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "ephemeralpg";
  version = "3.4";
  src = fetchurl {
    url = "https://eradman.com/ephemeralpg/code/${pname}-${version}.tar.gz";
    hash = "sha256-IwAIJFW/ahDXGgINi4N9mG3XKw74JXK6+SLxGMZ8tS0=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    PREFIX=$out make install
    wrapProgram $out/bin/pg_tmp --prefix PATH : ${
      lib.makeBinPath [
        postgresql
        getopt
      ]
    }
  '';
  meta = with lib; {
    description = "Run tests on an isolated, temporary PostgreSQL database";
    license = licenses.isc;
    homepage = "https://eradman.com/ephemeralpg/";
    platforms = platforms.all;
    maintainers = with maintainers; [
      hrdinka
      medv
    ];
  };
}

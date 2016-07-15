{ stdenv, fetchurl, zlib }:
stdenv.mkDerivation rec {
  name = "glucose-syrup-${version}";
  version = "4.0";

  src = fetchurl {
    url = "http://www.labri.fr/perso/lsimon/downloads/softwares/glucose-syrup.tgz";
    sha256 = "0bq5l2jabhdfhng002qfk0mcj4pfi1v5853x3c7igwfrgx0jmfld";
  };

  buildInputs = [ zlib ];

  sourceRoot = "glucose-syrup/parallel";
  makeFlags = [ "r" ];
  installPhase = ''
    install -Dm0755 glucose-syrup_release $out/bin/glucose-syrup
  '';

  meta = with stdenv.lib; {
    description = "Modern, parallel SAT solver (parallel version)";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}

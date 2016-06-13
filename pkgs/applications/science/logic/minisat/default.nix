{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "minisat-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "http://minisat.se/downloads/${name}.tar.gz";
    sha256 = "023qdnsb6i18yrrawlhckm47q8x0sl7chpvvw3gssfyw3j2pv5cj";
  };

  patches = stdenv.lib.optionals stdenv.cc.isClang [ ./clang.diff ];

  buildInputs = [ zlib ];

  preBuild = "cd simp";
  makeFlags = [ "r" "MROOT=.." ];
  installPhase = ''
    mkdir -p $out/bin
    cp minisat_release $out/bin/minisat
  '';

  meta = with stdenv.lib; {
    description = "Compact and readable SAT solver";
    maintainers = with maintainers; [ gebner raskin ];
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = "http://minisat.se/";
  };
}

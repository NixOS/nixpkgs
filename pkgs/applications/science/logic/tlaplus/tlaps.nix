{ fetchurl
, stdenv
, ocaml, isabelle, cvc3, perl, wget, which
}:

stdenv.mkDerivation rec {
  pname = "tlaps";
  version = "1.4.3";
  src = fetchurl {
    url = "https://tla.msr-inria.inria.fr/tlaps/dist/current/tlaps-${version}.tar.gz";
    sha256 = "1w5z3ns5xxmhmp8r4x2kjmy3clqam935gmvx82imyxrr1bamx6gf";
  };

  buildInputs = [ ocaml isabelle cvc3 perl wget which ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -pv "$out"
    export HOME="$out"
    export PATH=$out/bin:$PATH

    pushd zenon
    ./configure --prefix $out
    make
    make install
    popd

    pushd isabelle
    isabelle build -b Pure
    popd

    pushd tlapm
    ./configure --prefix $out
    make all
    make install
  '';

  meta = {
    description = "Mechanically check TLA+ proofs";
    longDescription = ''
      TLA+ is a general-purpose formal specification language that is
      particularly useful for describing concurrent and distributed
      systems. The TLA+ proof language is declarative, hierarchical,
      and scalable to large system specifications. It provides a
      consistent abstraction over the various “backend” verifiers.
    '';
    homepage    = "https://tla.msr-inria.inria.fr/tlaps/content/Home.html";
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.badi ];
  };

}

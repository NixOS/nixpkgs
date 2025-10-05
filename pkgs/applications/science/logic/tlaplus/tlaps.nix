{
  fetchurl,
  lib,
  stdenv,
  ocaml,
  isabelle,
  cvc3,
  perl,
  wget,
  which,
}:

stdenv.mkDerivation rec {
  pname = "tlaps";
  version = "1.4.5";
  src = fetchurl {
    url = "https://tla.msr-inria.inria.fr/tlaps/dist/${version}/tlaps-${version}.tar.gz";
    sha256 = "c296998acd14d5b93a8d5be7ee178007ef179957465966576bda26944b1b7fca";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    isabelle
    cvc3
    perl
    wget
    which
  ];

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
    homepage = "https://tla.msr-inria.inria.fr/tlaps/content/Home.html";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ florentc ];
  };

}

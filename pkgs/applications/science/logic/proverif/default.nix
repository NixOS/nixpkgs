{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "proverif-${version}";
  version = "1.97pl1";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif${version}.tar.gz";
    sha256 = "1b0ji68crdli40a4z62gdq6fnygj3z2j63iaq4jki7wfc3nn3vgq";
  };

  buildInputs = [ ocaml ];

  buildPhase = "./build";
  installPhase = ''
    mkdir -p $out/bin
    cp ./proverif      $out/bin
    cp ./proveriftotex $out/bin
  '';

  meta = {
    description = "Cryptographic protocol verifier in the Dolev-Yao model";
    homepage    = "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

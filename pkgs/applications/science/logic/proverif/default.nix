{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "proverif-${version}";
  version = "1.95";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif${version}.tar.gz";
    sha256 = "01viwi6sccdxk723ycy1shklz8g29j5i3wj2mcwb3j7advvqmws2";
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

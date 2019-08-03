{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "proverif-${version}";
  version = "2.00";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif${version}.tar.gz";
    sha256 = "0vjphj85ch9q39vc7sd6n4vxy5bplp017vlshk989yhfwb00r37y";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib lablgtk ];

  buildPhase = "./build";
  installPhase = ''
    mkdir -p $out/bin
    cp ./proverif      $out/bin
    cp ./proveriftotex $out/bin
  '';

  meta = {
    description = "Cryptographic protocol verifier in the Dolev-Yao model";
    homepage    = "https://prosecco.gforge.inria.fr/personal/bblanche/proverif/";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

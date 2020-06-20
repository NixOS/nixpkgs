{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "proverif";
  version = "2.01";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif${version}.tar.gz";
    sha256 = "01wp5431c77z0aaa99h8bnm5yhr6jslpqc8iyg0a7gxfqnb19gxi";
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

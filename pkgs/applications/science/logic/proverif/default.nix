{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "proverif-${version}";
  version = "1.94";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif${version}.tar.gz";
    sha256 = "0dv2hgk76y0ap7dwf80qd94dmxjw47c50iavxgq5702k1d6qap56";
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

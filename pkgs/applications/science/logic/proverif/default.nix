{ lib, stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "proverif";
  version = "2.02pl1";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif${version}.tar.gz";
    sha256 = "1jmzfpx0hdgfmkq0jp6i3k5av9xxgndjaj743wfy37svn0ga4jjx";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib lablgtk ];

  buildPhase = "./build";
  installPhase = ''
    mkdir -p $out/bin
    cp ./proverif      $out/bin
    cp ./proveriftotex $out/bin
    install -D -t $out/share/emacs/site-lisp/ emacs/proverif.el
  '';

  meta = {
    description = "Cryptographic protocol verifier in the Dolev-Yao model";
    homepage    = "https://prosecco.gforge.inria.fr/personal/bblanche/proverif/";
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}

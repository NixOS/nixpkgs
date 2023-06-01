{ lib, stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "proverif";
  version = "2.04";

  src = fetchurl {
    url    = "https://bblanche.gitlabpages.inria.fr/proverif/proverif${version}.tar.gz";
    sha256 = "sha256:0xgwnp59779xc40sb7ck8rmfn620pilxyq79l3bymj9m7z0mwvm9";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [ ocaml findlib ];

  buildPhase = "./build -nointeract";
  installPhase = ''
    runHook preInstall
    install -D -t $out/bin proverif proveriftotex
    install -D -t $out/share/emacs/site-lisp/ emacs/proverif.el
    runHook postInstall
  '';

  meta = {
    description = "Cryptographic protocol verifier in the formal model";
    homepage    = "https://bblanche.gitlabpages.inria.fr/proverif/";
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice vbgl ];
  };
}

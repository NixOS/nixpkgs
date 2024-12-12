{
  lib,
  stdenv,
  fetchurl,
  ocamlPackages,
}:

stdenv.mkDerivation rec {
  pname = "proverif";
  version = "2.05";

  src = fetchurl {
    url = "https://bblanche.gitlabpages.inria.fr/proverif/proverif${version}.tar.gz";
    hash = "sha256-SHH1PDKrSgRmmgYMSIa6XZCASWlj+5gKmmLSxCnOq8Q=";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
  ];

  buildPhase = "./build -nointeract";
  installPhase = ''
    runHook preInstall
    install -D -t $out/bin proverif proveriftotex
    install -D -t $out/share/emacs/site-lisp/ emacs/proverif.el
    runHook postInstall
  '';

  meta = {
    description = "Cryptographic protocol verifier in the formal model";
    homepage = "https://bblanche.gitlabpages.inria.fr/proverif/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      vbgl
    ];
  };
}

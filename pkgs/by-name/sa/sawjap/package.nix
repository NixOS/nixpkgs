{
  stdenv,
  ocamlPackages,
}:

stdenv.mkDerivation {

  pname = "sawjap";

  inherit (ocamlPackages.sawja) src version;

  prePatch = "cd test";

  strictDeps = true;

  nativeBuildInputs = [
    ocamlPackages.ocaml
    ocamlPackages.findlib
  ];
  buildInputs = [ ocamlPackages.sawja ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/bin
    ocamlfind opt -o $out/bin/sawjap -package sawja -linkpkg sawjap.ml
    runHook postBuild
  '';

  dontInstall = true;

  meta = ocamlPackages.sawja.meta // {
    description = "Pretty-print .class files";
    mainProgram = "sawjap";
  };

}

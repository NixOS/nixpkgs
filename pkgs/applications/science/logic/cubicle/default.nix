{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  which,
  ocamlPackages,
}:

stdenv.mkDerivation rec {
  pname = "cubicle";
  version = "1.2.0";
  src = fetchurl {
    url = "https://github.com/cubicle-model-checker/cubicle/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-/EtbXpyXqRm0jGcMfGLAEwdr92061edjFys1V7/w6/Y=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    which
  ]
  ++ (with ocamlPackages; [
    findlib
    ocaml
  ]);

  buildInputs = with ocamlPackages; [
    functory
    num
  ];

  # https://github.com/cubicle-model-checker/cubicle/issues/1
  env = {
    OCAMLC = "ocamlfind ocamlc -package num";
    OCAMLOPT = "ocamlfind ocamlopt -package num";
  };

  meta = with lib; {
    description = "Open source model checker for verifying safety properties of array-based systems";
    mainProgram = "cubicle";
    homepage = "https://cubicle.lri.fr/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dwarfmaster ];
  };
}

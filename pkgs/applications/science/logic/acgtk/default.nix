{ lib, stdenv, fetchFromGitLab, dune_2, ocamlPackages }:

stdenv.mkDerivation {

  pname = "acgtk";
  version = "1.5.4";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "acg";
    repo = "dev/acgtk";
    rev = "8e630b6d91bad022bd1d1a075e7768034065c428";
    sha256 = "sha256-W/BDhbng5iYuiB7desMKvRtDFdhoaxiJNvNvtbLlA6E=";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [ menhir ocaml findlib dune_2 ];

  buildInputs = with ocamlPackages; [
    ansiterminal cairo2 cmdliner fmt logs menhirLib mtime sedlex yojson
  ];

  buildPhase = ''
    runHook preBuild
    dune build --profile=release ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';

  installPhase = ''
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR
  '';

  meta = with lib; {
    homepage = "https://acg.loria.fr/";
    description = "A toolkit for developing ACG signatures and lexicon";
    license = licenses.cecill20;
    inherit (ocamlPackages.ocaml.meta) platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}

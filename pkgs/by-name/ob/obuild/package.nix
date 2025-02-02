{ lib, stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "obuild";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "ocaml-obuild";
    repo = "obuild";
    rev = "obuild-v${version}";
    hash = "sha256-me9/FVD7S0uPIpFZzcxDfYKVWn9ifq6JryBAGCo681I=";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [ ocaml findlib ];

  buildPhase = ''
    patchShebangs ./bootstrap
    ./bootstrap
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dist/build/obuild/obuild dist/build/obuild-from-oasis/obuild-from-oasis dist/build/obuild-simple/obuild-simple $out/bin/
  '';

  meta = {
    homepage = "https://github.com/ocaml-obuild/obuild";
    inherit (ocamlPackages.ocaml.meta) platforms;
    description = "Simple package build system for OCaml";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
}

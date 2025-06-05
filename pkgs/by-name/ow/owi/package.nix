{
  lib,
  ocaml-ng,
  fetchFromGitHub,
  rustc,
  llvmPackages,
  unstableGitUpdater,
}:

let
  ocamlPackages = ocaml-ng.ocamlPackages_5_1;
in
ocamlPackages.buildDunePackage rec {
  pname = "owi";
  version = "0.2-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "owi";
    rev = "bc4e1369a1d1f0ab0af2c7031e3a5da59648609b";
    fetchSubmodules = true;
    hash = "sha256-ho+hQljf5wopLD0Yr33U9nvWOZp0K3FL510r6dyehuE=";
  };

  nativeBuildInputs = with ocamlPackages; [
    findlib
    menhir
    rustc
    # unwrapped because wrapped tries to enforce a target and the build
    # script wants to do its own thing
    llvmPackages.clang-unwrapped
    # lld isn't included in unwrapped, so we pull it in here
    llvmPackages.lld
  ];

  buildInputs = with ocamlPackages; [
    bos
    cmdliner
    digestif
    dolmen_type
    dune-build-info
    dune-site
    hc
    integers
    menhir
    menhirLib
    ocaml_intrinsics
    patricia-tree
    prelude
    processor
    pyml
    re2
    scfg
    sedlex
    smtml
    uutf
    xmlm
    yojson
    z3
    zarith
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Symbolic execution for Wasm, C, C++, Rust and Zig";
    homepage = "https://ocamlpro.github.io/owi/";
    downloadPage = "https://github.com/OCamlPro/owi";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}

{
  lib,
  ocaml-ng,
  fetchFromGitHub,
  llvmPackages,
  rustc,
  zig,
  makeWrapper,
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
    rev = "e4c2e85f1364714a77a925ec29321cf9b8fe90f4";
    fetchSubmodules = true;
    hash = "sha256-ewaAkSyxtiiE8WcHusOyZDesqI61kCEN3pMb99R7Dkw=";
  };

  nativeBuildInputs = with ocamlPackages; [
    findlib
    menhir
    # unwrapped because wrapped tries to enforce a target and the build
    # script wants to do its own thing
    llvmPackages.clang-unwrapped
    # lld + llc isn't included in unwrapped, so we pull it in here
    llvmPackages.bintools-unwrapped
    rustc
    zig
    makeWrapper
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

  postInstall = ''
    wrapProgram $out/bin/owi \
      --prefix PATH : ${
        lib.makeBinPath [
          llvmPackages.bintools-unwrapped
          llvmPackages.clang-unwrapped
          rustc
          zig
        ]
      }
  '';

  doCheck = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Symbolic execution for Wasm, C, C++, Rust and Zig";
    homepage = "https://ocamlpro.github.io/owi/";
    downloadPage = "https://github.com/OCamlPro/owi";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ethancedwards8 ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "owi";
  };
}

{
  lib,
  ocaml-ng,
  fetchFromGitHub,
  llvmPackages,
  rustc,
  zig,
  makeWrapper,
  unstableGitUpdater,
  nixosTests,
}:

let
  ocamlPackages = ocaml-ng.ocamlPackages_5_4;
in
ocamlPackages.buildDunePackage {
  pname = "owi";
  version = "0.2-unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "owi";
    rev = "7fb7af27025501c732d8dda903865b47bc5d4901";
    fetchSubmodules = true;
    hash = "sha256-aRNJiW6UTcpJU3fIcEQB3gujmAxsp2dwR1hFeWJrhzs=";
  };

  nativeBuildInputs = with ocamlPackages; [
    findlib
    menhir
    # unwrapped because wrapped tries to enforce a target and the build
    # script wants to do its own thing
    llvmPackages.clang-unwrapped
    # lld + llc isn't included in unwrapped, so we pull it in here
    llvmPackages.bintools-unwrapped
    makeWrapper
    rustc
    zig
  ];

  buildInputs = with ocamlPackages; [
    dune-build-info
    dune-site
  ];

  propagatedBuildInputs = with ocamlPackages; [
    bos
    cmdliner
    digestif
    domainpc
    menhirLib
    ocaml_intrinsics
    ocamlgraph
    prelude
    processor
    scfg
    sedlex
    smtml
    symex
    synchronizer
    uutf
    xmlm
    yojson
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

  passthru = {
    updateScript = unstableGitUpdater { };
    tests = { inherit (nixosTests) owi; };
  };

  meta = {
    description = "Symbolic execution for Wasm, C, C++, Rust and Zig";
    homepage = "https://ocamlpro.github.io/owi/";
    downloadPage = "https://github.com/OCamlPro/owi";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      ethancedwards8
      redianthus
    ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "owi";
    badPlatforms = lib.platforms.darwin;
  };
}

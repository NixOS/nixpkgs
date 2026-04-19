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
  version = "0.2-unstable-2026-04-18";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "owi";
    rev = "19bfe6f8766d860c4a20a6c3fb18f6b9fd0bde50";
    fetchSubmodules = true;
    hash = "sha256-+89ftleJVM2l46dF6UZaGsJnKJWmV1yTwXdRWlTLDZI=";
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

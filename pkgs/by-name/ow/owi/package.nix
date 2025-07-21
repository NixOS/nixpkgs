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
  ocamlPackages = ocaml-ng.ocamlPackages_5_2;
in
ocamlPackages.buildDunePackage rec {
  pname = "owi";
  version = "0.2-unstable-2025-07-11";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "owi";
    rev = "be3d93320dcbf7d4e991f9b240ff490b5a1b0acc";
    fetchSubmodules = true;
    hash = "sha256-yc/f/N+smGk3NwtZnP/k4ISN3mvp1GL9VTcjgosbQJw=";
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
    bos
    cmdliner
    digestif
    dolmen_type
    dune-build-info
    dune-site
    hc
    integers
    menhirLib
    ocaml_intrinsics
    patricia-tree
    prelude
    processor
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
    badPlatforms = lib.platforms.darwin;
  };
}

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
  ocamlPackages = ocaml-ng.ocamlPackages_5_2;
in
ocamlPackages.buildDunePackage rec {
  pname = "owi";
  version = "0.2-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "owi";
    rev = "40c6434ecdb0cf7248b98670526e18dc007b425b";
    fetchSubmodules = true;
    hash = "sha256-N/DO3vml7vzOjPi81LPOL+ZuI8CewAhANM9j4nuRbyU=";
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

  passthru = {
    updateScript = unstableGitUpdater { };
    tests = { inherit (nixosTests) owi; };
  };

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

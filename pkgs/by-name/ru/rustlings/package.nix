{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cargo,
  rustc,
  clippy,
  gcc,
  makeWrapper,
}:
let
  pname = "rustlings";
  version = "6.4.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustlings";
    rev = "v${version}";
    hash = "sha256-VdIIcpyoCuid3MECVc9aKeIOUlxGlxcG7znqbqo9pjc=";
  };

  cargoHash = "sha256-QWmK+chAUnMGjqLq2xN5y6NJZJBMDTszImB9bXhO4+w=";

  # Disabled test that does not work well in an isolated environment
  checkFlags = [
    "--skip=run_compilation_success"
    "--skip=run_test_success"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/rustlings --suffix PATH : ${
      lib.makeBinPath [
        cargo
        rustc
        clippy
        gcc
      ]
    }
  '';

  meta = {
    description = "Explore the Rust programming language and learn more about it while doing exercises";
    homepage = "https://rustlings.cool/";
    changelog = "https://github.com/rust-lang/rustlings/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "rustlings";
  };
}

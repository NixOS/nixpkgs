{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cargo,
  rustc,
  clippy,
  makeWrapper,
}:
let
  pname = "rustlings";
  version = "6.2.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustlings";
    rev = "v${version}";
    hash = "sha256-BVmiMIIx8YEO57FO0ZpsCQcim68mn7NHpAOO86dZqlI=";
  };

  cargoHash = "sha256-ZupwPw/bfeN+s7IWXbY21K/ODXSaYef+IDDpBVCi3Ek=";

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

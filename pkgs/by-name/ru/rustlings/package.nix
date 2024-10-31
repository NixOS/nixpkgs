{
  lib,
  stdenv,
  darwin,
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
  version = "6.3.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustlings";
    rev = "v${version}";
    hash = "sha256-te7DYgbEtWWSSvO28ajkJucRb3c9L8La1wfGW0WSxW0=";
  };

  cargoHash = "sha256-Vq4Os4CKkEz4HggIZhlbIo9Cu+BVJPdybL1CNvz5wEQ=";

  # Disabled test that does not work well in an isolated environment
  checkFlags = [
    "--skip=run_compilation_success"
    "--skip=run_test_success"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks; [ CoreServices ]
  );

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

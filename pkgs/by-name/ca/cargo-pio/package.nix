{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-pio";
  version = "0.25.6";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "embuild";
    rev = "cargo-pio-v${version}";
    hash = "sha256-YH2CPb3uBlPncd+KkP25xhCVvDB7HDxJuSqWOJ1LT3k=";
  };

  cargoHash = "sha256-/WBhgPyd5hR3DBYvV8pd7uZb6FeD3yiDe3wOKtyFRG8=";

  buildAndTestSubdir = "cargo-pio";

  meta = with lib; {
    description = "Build Rust embedded projects with PlatformIO";
    homepage = "https://github.com/esp-rs/embuild/tree/master/cargo-pio";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ dannixon ];
    mainProgram = "cargo-pio";
  };
}

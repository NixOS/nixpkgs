{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-pio";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "embuild";
    rev = "cargo-pio-v${finalAttrs.version}";
    hash = "sha256-BOkzaJ9GFkrZaXRFXwvECHFSNL091Rf5WZu4f69B6IQ=";
  };

  cargoHash = "sha256-S3aoNON25W6IX+2V6AlyJr0gBYD3iikGwfV9+/Mj3zo=";

  buildAndTestSubdir = "cargo-pio";

  meta = {
    description = "Build Rust embedded projects with PlatformIO";
    homepage = "https://github.com/esp-rs/embuild/tree/master/cargo-pio";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "cargo-pio";
  };
})

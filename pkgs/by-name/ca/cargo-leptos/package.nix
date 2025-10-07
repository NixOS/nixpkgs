{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.2.45";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = "cargo-leptos";
    rev = "v${version}";
    hash = "sha256-Ma1nxNB3B+Ru9P3n6nNzq7EcZYm1AmIzaWhluSpJA5o=";
  };

  cargoHash = "sha256-gSsvazkE9UFrMQYoOMGmK/AQV9IdkqKM5w+hmVvDPik=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Fix for C++ compiler version on darwin for wasm-opt
    CRATE_CC_NO_DEFAULTS = 1;
  };

  # https://github.com/leptos-rs/cargo-leptos#dependencies
  buildFeatures = [ "no_downloads" ]; # cargo-leptos will try to install missing dependencies on its own otherwise
  doCheck = false; # Check phase tries to query crates.io

  meta = {
    description = "Build tool for the Leptos web framework";
    mainProgram = "cargo-leptos";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    changelog = "https://github.com/leptos-rs/cargo-leptos/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ benwis ];
  };
}

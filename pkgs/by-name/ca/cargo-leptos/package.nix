{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-leptos";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = "cargo-leptos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OhGppUYbRnsYjuiu3Sys+073o4ZiVqMqlt8apeY7Oho=";
  };

  cargoHash = "sha256-ou8swAP0W8jOab9yTvA/7mFkvI6YskXUsqLNHzIJdiY=";

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
    changelog = "https://github.com/leptos-rs/cargo-leptos/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ benwis ];
  };
})

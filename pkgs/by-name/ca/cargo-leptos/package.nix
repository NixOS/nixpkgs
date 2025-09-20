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
  version = "0.2.43";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = "cargo-leptos";
    rev = "v${version}";
    hash = "sha256-n3AtVm2+97T+zXbMwch5LWkzrTE2mmvGGBEKmlD/Bco=";
  };

  cargoHash = "sha256-Btq6z/erDjskpN4n+W0n1oGs13OUroKSDKXoDYan7L0=";

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

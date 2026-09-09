{
  cacert,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "buzz-cli";
  version = "0.1.0-unstable-2026-08-27";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    rev = "0808ab485c39c3c12ef02af2188c65a5145eb99d";
    hash = "sha256-+vYRX6yZmyWxtpcaQj62ujmcG2uwo3fdaX5Oo6Q1jEE=";
  };

  cargoHash = "sha256-y067FJWvsJAe6mvtnLPSW1YK0/gcBrKuZX45OCO8/2U=";
  cargoBuildFlags = [ "--package=buzz-cli" ];
  cargoTestFlags = [ "--package=buzz-cli" ];

  # reqwest initializes its rustls client in tests and needs a CA bundle.
  nativeCheckInputs = [ cacert ];

  env = lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) {
    # Avoid nondeterministic LC_UUIDs emitted by ld64 on arm64.
    RUSTFLAGS = "-C link-arg=-Wl,-no_uuid";
  };

  preBuild = ''
    # Remap transient Nix build paths for reproducible output.
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
    export NIX_CFLAGS_COMPILE="-ffile-prefix-map=$NIX_BUILD_TOP=/build ''${NIX_CFLAGS_COMPILE:-}"
  '';

  meta = {
    description = "Agent-first CLI for Buzz relay";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "buzz";
    maintainers = [ lib.maintainers.sebfried ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

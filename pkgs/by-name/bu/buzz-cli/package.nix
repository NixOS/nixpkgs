{
  cacert,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "buzz-cli";
  version = "0.1.0-unstable-2026-09-02";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    rev = "47d068e2109d077414cbf2f4f1c927f6d051037a";
    hash = "sha256-sLIyStOy330KzzVF9QnIn27loT5QXCRz0U4NN9bxU40=";
  };

  cargoHash = "sha256-q8FUmTHnPfy/Ub+TNs3UK3exOoX1GdZGwHkH5pDteKE=";
  cargoBuildFlags = [ "--package=buzz-cli" ];
  cargoTestFlags = [ "--package=buzz-cli" ];

  # reqwest initializes its rustls client in tests and needs a CA bundle.
  nativeCheckInputs = [ cacert ];

  # Make darwin builds reproducible by disabling debug symbols in ring.
  # See: https://github.com/briansmith/ring/pull/2881
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace "$cargoDepsCopy"/source-registry-*/ring-0.17.14/build.rs \
      --replace-fail 'c.flag("-gfull")' 'c.flag("-g0")'
  '';

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
    maintainers = with lib.maintainers; [
      sebfried
      kleinbem
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

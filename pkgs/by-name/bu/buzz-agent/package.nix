{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "buzz-agent";
  version = "0.1.0-unstable-2026-10-03";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    rev = "e982f70fba29cdaa9a8378f118a0e498537bd8db";
    hash = "sha256-P64V50KiTBwDmsEZDpF+MDWztpqog+SI6s5wL+b6YtI=";
  };

  cargoHash = "sha256-9EwiWYHgvjt2l8q/QhgTU9LzNVevS1jwoQA4pZG+GAA=";

  cargoBuildFlags = [
    "--package=buzz-agent"
    "--bin=buzz-agent"
  ];

  cargoTestFlags = [
    "--package=buzz-agent"
  ];

  checkFlags = [
    # Test executes the `buzz-agent` binary via `.env_clear()`, which strips `SSL_CERT_FILE`
    # and fails TLS root initialization inside the Nix build sandbox.
    "--skip=cli_signin_aliases_reuse_legacy_cache_without_runtime_configuration"
  ];

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

  postInstall = ''
    # Remove test-only binaries if any were installed
    rm -f $out/bin/fake-mcp $out/bin/lock-holder $out/bin/auth-worker
  '';

  meta = {
    description = "Minimal, unbreakable ACP-compliant agent for the Buzz workspace";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "buzz-agent";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

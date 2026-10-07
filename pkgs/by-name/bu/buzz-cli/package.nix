{
  cacert,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "buzz-cli";
  # The CLI crates have no releases of their own: build the workspace at Buzz
  # Desktop releases, which ship these binaries.
  version = "0.1.0-unstable-2026-10-06";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    tag = "desktop-v0.5.27";
    hash = "sha256-h/4xEemRexKpjz4ZD9XKGSL+0vizdx5QuqmVO3oO7W4=";
  };

  cargoHash = "sha256-e2vWeSx9JTjHqupOMkNpD+0vNCs8ubMm/lRp+RVRK78=";
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

  passthru.updateScript = ./update.sh;

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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  systemd,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libsideswap-client";
  version = "0-unstable-2026-09-23";

  # This version is pinned in https://github.com/sideswap-io/sideswapclient/blob/v1.9.2/deploy/build_linux.sh
  src = fetchFromGitHub {
    owner = "sideswap-io";
    repo = "sideswap_rust";
    rev = "9ceeb0906f82e3d7aa41af8b7ee4b94480abd181";
    hash = "sha256-fYBoCWSig+2QKqDJvBbX2ZR6jM7nHUEjuTa1X9OtDvA=";
  };

  cargoHash = "sha256-Tl+wKTIOXQm7rqwKR118N3HPeNRKfCbGve76bz2ll9M=";

  # The source archive has no .git directory for vergen to inspect.
  env.VERGEN_GIT_SHA = finalAttrs.src.rev;

  # This is needed for pkg-config to find libudev. It is a part of systemd.
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ systemd ];

  cargoBuildFlags = [
    "--package"
    "sideswap_client"
  ];

  # Test gdk_registry_cache::tests::basic hangs in Nix build invironment.
  doCheck = false;

  meta = {
    description = "Rust library for Sideswap";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ starius ];
  };
})

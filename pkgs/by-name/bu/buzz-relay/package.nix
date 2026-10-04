{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  perl,
  protobuf,
  openssl,
  bash,
  git,
  makeWrapper,
}:

rustPlatform.buildRustPackage {
  pname = "buzz-relay";
  version = "0.1.0-unstable-2026-10-03";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    rev = "e982f70fba29cdaa9a8378f118a0e498537bd8db";
    hash = "sha256-P64V50KiTBwDmsEZDpF+MDWztpqog+SI6s5wL+b6YtI=";
  };

  cargoHash = "sha256-9EwiWYHgvjt2l8q/QhgTU9LzNVevS1jwoQA4pZG+GAA=";

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    protobuf
    makeWrapper
  ];

  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace crates/buzz-relay/src/api/git/hook.rs \
      --replace-fail '#!/usr/bin/env bash' '#!${lib.getExe bash}'
  '';

  # cmake is only used by dependency build scripts; avoid overriding cargo configurePhase
  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package=buzz-relay"
    "--package=buzz-admin"
    "--package=buzz-pair-relay"
  ];

  # Full workspace tests require live Postgres, Redis, and S3 services
  doCheck = false;

  preBuild = ''
    # Remap transient Nix build paths for reproducible output.
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
    export NIX_CFLAGS_COMPILE="-ffile-prefix-map=$NIX_BUILD_TOP=/build ''${NIX_CFLAGS_COMPILE:-}"
  '';

  postInstall = ''
    wrapProgram $out/bin/buzz-relay \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          bash
        ]
      }
  '';

  meta = {
    description = "Relay server, admin CLI, and pairing relay for the Buzz decentralized workspace";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "buzz-relay";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  makeWrapper,
}:

rustPlatform.buildRustPackage {
  pname = "git-sign-nostr";
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

  patches = [
    # Fix BIP-340 curve point validation under nostr 0.44 (upstream issue #6175)
    ./fix-bip340-pubkey-validation.patch
  ];

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ git ];

  cargoBuildFlags = [ "--package=git-sign-nostr" ];
  cargoTestFlags = [ "--package=git-sign-nostr" ];

  preBuild = ''
    # Remap transient Nix build paths for reproducible output.
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
    export NIX_CFLAGS_COMPILE="-ffile-prefix-map=$NIX_BUILD_TOP=/build ''${NIX_CFLAGS_COMPILE:-}"
  '';

  postInstall = ''
    wrapProgram $out/bin/git-sign-nostr \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = {
    description = "NIP-GS git commit/tag signing program using Nostr secp256k1 keys";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "git-sign-nostr";
    maintainers = with lib.maintainers; [ kleinbem ];
  };
}

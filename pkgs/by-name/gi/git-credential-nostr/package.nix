{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  makeWrapper,
}:

rustPlatform.buildRustPackage {
  pname = "git-credential-nostr";
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

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ git ];

  cargoBuildFlags = [ "--package=git-credential-nostr" ];
  cargoTestFlags = [ "--package=git-credential-nostr" ];

  preBuild = ''
    # Remap transient Nix build paths for reproducible output.
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
    export NIX_CFLAGS_COMPILE="-ffile-prefix-map=$NIX_BUILD_TOP=/build ''${NIX_CFLAGS_COMPILE:-}"
  '';

  postInstall = ''
    wrapProgram $out/bin/git-credential-nostr \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = {
    description = "Git credential helper producing NIP-98 authentication headers for Nostr git repositories";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "git-credential-nostr";
    maintainers = with lib.maintainers; [ kleinbem ];
  };
}

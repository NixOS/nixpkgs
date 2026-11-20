{
  lib,
  stdenv,
  aws-lc,
  darwin,
  fetchFromGitHub,
  fetchurl,
  libusb1,
  nix-update-script,
  perl,
  pkg-config,
  rust-jemalloc-sys,
  rustPlatform,
  sqlite,
  versionCheckHook,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "foundry";
  version = "1.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9k+78ednqFo8/rdGDOWqS8Y+eZ/6kxFd5Ojit/pjeJM=";
  };

  cargoHash = "sha256-LBhRrQ1N6ygZZ6hApX+WOtZmKypmO95fOThIo+tyZks=";

  # Cargo vendoring drops the tempo repository root, where tempo-chainspec's build.rs looks for these files.
  postPatch =
    let
      tempoIdentity =
        network: hash:
        fetchurl {
          url = "https://raw.githubusercontent.com/tempoxyz/tempo/9634fed25ed0b19d7d7680c949a1706181a4086f/${network}-network-identity.json";
          inherit hash;
        };
    in
    ''
      for crate in "$cargoDepsCopy"/source-git-*/tempo-chainspec-*; do
        cp ${tempoIdentity "mainnet" "sha256-XZakmOuroaTfsx9N4yDDMjqktcqyCd7F9wW3HtxyWkU="} "$crate/mainnet-network-identity.json"
        cp ${tempoIdentity "testnet" "sha256-wIVvzfPgpguSaTZjnLnFfGGaLrJQdlE+aNVn35x2KpU="} "$crate/testnet-network-identity.json"
      done
    '';

  nativeBuildInputs = [
    # `sha3-asm`'s build script runs cryptogams perl scripts to generate
    # Keccak assembly, so perl must be available at build time.
    perl
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  buildInputs = [
    aws-lc
    rust-jemalloc-sys
    sqlite
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libusb1 ];

  # Tests are run upstream, and many perform I/O
  # incompatible with the nix build sandbox.
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/forge";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  env = {
    # The build script in `crates/common/build.rs` uses vergen to embed
    # `git describe` / SHA output, but the GitHub source tarball has no `.git`
    # directory. Pre-set the values so vergen reuses them instead of shelling
    # out to git.
    VERGEN_GIT_SHA = finalAttrs.src.rev;
    VERGEN_GIT_DESCRIBE = "v${finalAttrs.version}";

    SVM_RELEASES_LIST_JSON =
      if stdenv.hostPlatform.isDarwin then
        # Confusingly, these are universal binaries, not amd64.
        # See: https://github.com/ethereum/solidity/issues/12291#issuecomment-1974771433
        "${./svm-lists/macosx-amd64.json}"
      else
        "${./svm-lists/linux-amd64.json}";
  };

  meta = {
    homepage = "https://github.com/foundry-rs/foundry";
    description = "Portable, modular toolkit for Ethereum application development written in Rust";
    changelog = "https://github.com/foundry-rs/foundry/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      beeb
      mitchmindtree
      msanft
      samooyo
    ];
    platforms = lib.platforms.unix;
  };
})

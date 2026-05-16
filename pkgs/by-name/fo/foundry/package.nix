{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  libusb1,
  nix-update-script,
  perl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "foundry";
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UCaBo4hMStmh79UiyYu7vEO7UtrvwJshe4PTMkqZV0w=";
  };

  cargoHash = "sha256-iAWUEVgOgn2Zw9fINxyH9Bynh+flzCY40YFGoVLgG8k=";

  strictDeps = true;

  nativeBuildInputs = [
    # `sha3-asm`'s build script runs cryptogams perl scripts to generate
    # Keccak assembly, so perl must be available at build time.
    perl
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libusb1 ];

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
    changelog = "https://github.com/foundry-rs/foundry/blob/v${finalAttrs.version}/CHANGELOG.md";
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

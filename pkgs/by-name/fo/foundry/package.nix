{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  libusb1,
  nix-update-script,
  pkg-config,
  rustPlatform,
  solc,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "foundry";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SrkFfc9+cb3nDqEOj3gRkQq9aKOSfk3s7a3EGka5ACw=";
  };

  cargoHash = "sha256-PoPfuMNeK6ArZddBd0lsR2r8UrvRieqkxYZ8jCCxw5o=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  buildInputs = [ solc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libusb1 ];

  # Tests are run upstream, and many perform I/O
  # incompatible with the nix build sandbox.
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/forge";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  env = {
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
    ];
    platforms = lib.platforms.unix;
  };
})

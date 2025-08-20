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

rustPlatform.buildRustPackage rec {
  pname = "foundry";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    tag = "v${version}";
    hash = "sha256-SdxcNbe8/dNZ4JcxKksWmDBAvQorpC8ePvQgnyeKgxU=";
  };

  cargoHash = "sha256-PQbp9jZZB/dsyKAlckZwl8xOpXks3anqUm+Ld7IhMFI=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [ darwin.DarwinTools ];

  buildInputs = [ solc ] ++ lib.optionals stdenv.isDarwin [ libusb1 ];

  # Tests are run upstream, and many perform I/O
  # incompatible with the nix build sandbox.
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/forge";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  env = {
    SVM_RELEASES_LIST_JSON =
      if stdenv.isDarwin then
        # Confusingly, these are universal binaries, not amd64.
        # See: https://github.com/ethereum/solidity/issues/12291#issuecomment-1974771433
        "${./svm-lists/macosx-amd64.json}"
      else
        "${./svm-lists/linux-amd64.json}";
  };

  meta = {
    homepage = "https://github.com/foundry-rs/foundry";
    description = "Portable, modular toolkit for Ethereum application development written in Rust.";
    changelog = "https://github.com/foundry-rs/foundry/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      mitchmindtree
      msanft
    ];
    platforms = lib.platforms.unix;
  };
}

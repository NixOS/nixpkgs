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
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-dMYuv5noIn86WuUJkUixnoNGLgByacung/TBU+EYhUw=";
  };

  cargoHash = "sha256-+5RLCkAQR8UepdUIsq1FnQmjKMg7YNC1Sxu0CVpWcnc=";
=======
    hash = "sha256-u+JCurH1gx4onC5Poxxd9+gVrUyyebcd6xnXY4Le6Rs=";
  };

  cargoHash = "sha256-JLuCZckiNv0t+kPuDk6TWmPIXKOvqf3HR/oFrQ5fKKQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

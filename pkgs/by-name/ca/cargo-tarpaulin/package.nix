{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  curl,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "cargo-tarpaulin";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
<<<<<<< HEAD
    tag = finalAttrs.version;
=======
    tag = version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-HJgcFQrHINm4BPfZ4c5ZHQYBTSBVYdSl/n0qBlSsNOI=";
  };

  cargoHash = "sha256-/IIO462dN1v7r05uDGo+QbH8gkSGa93StjLleP/KUPw=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  doCheck = false;

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Code coverage tool for Rust projects";
    mainProgram = "cargo-tarpaulin";
    homepage = "https://github.com/xd009642/tarpaulin";
    changelog = "https://github.com/xd009642/tarpaulin/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      hugoreeves
      progrm_jarvis
    ];
  };
})
=======
  meta = with lib; {
    description = "Code coverage tool for Rust projects";
    mainProgram = "cargo-tarpaulin";
    homepage = "https://github.com/xd009642/tarpaulin";
    changelog = "https://github.com/xd009642/tarpaulin/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      hugoreeves
    ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

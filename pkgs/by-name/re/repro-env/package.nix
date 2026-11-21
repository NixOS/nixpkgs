{
  lib,
  rustPlatform,
  fetchFromGitHub,
  aws-lc,
  pkg-config,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repro-env";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "repro-env";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t8VNpGTx2PdCtjMMcfbb92oUl5/t5Zao0OdGi3DH9HQ=";
  };

  cargoHash = "sha256-FG8GQyBwMa6CHtBqwc6POf3peqkRJ3R/e4KVCcTnME0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/kpcyrd/repro-env/releases/tag/v${finalAttrs.version}";
    description = "Dependency lockfiles for reproducible build environments";
    homepage = "https://github.com/kpcyrd/repro-env";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "repro-env";
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harper";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Gi9MCwc10aVEjPNNw4nIRwGcQo0uE0Hyd3+RrOaCH4c=";
  };

  buildAndTestSubdir = "harper-ls";

  cargoHash = "sha256-a3W2y9VVp6uHknsCwVkNRekQsxgq/IzcZQ+3m2Q3Rhk=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
      ddogfoodd
    ];
    mainProgram = "harper-ls";
  };
})

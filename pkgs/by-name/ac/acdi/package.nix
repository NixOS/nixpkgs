{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "acdi";
  version = "0.5.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vral-parmar";
    repo = "acdi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IYFsUi+MF6fjzSS+2Muoh08lD6tCMxz9wjubX7Inlbk=";
  };

  cargoHash = "sha256-J9raJea/7jjVdYn/8WvjkPDXzOs5jzPyyAWEsqr2BhM=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automated Cryptography Discovery & Inventory Scanner";
    homepage = "https://github.com/vral-parmar/acdi";
    changelog = "https://github.com/vral-parmar/acdi/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "acdi";
  };
})

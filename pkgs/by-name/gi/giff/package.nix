{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "giff";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "giff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ESmURQ7MAJ/Sv6ISdh+WF/XVtsGUTCRc7DzDwqBuXCM=";
  };

  cargoHash = "sha256-094QMCEI4ShTqlfYZUxCUUd/Fx9kmATHKuJPKqGxw7s=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based Git diff viewer with interactive rebase capabilities";
    homepage = "https://github.com/bahdotsh/giff";
    changelog = "https://github.com/bahdotsh/giff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      kpbaks
    ];
    mainProgram = "giff";
  };
})

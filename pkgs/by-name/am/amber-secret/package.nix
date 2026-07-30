{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  # Renaming it to amber-secret because another package named amber exists
  pname = "amber-secret";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "amber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nBC/IJgad7/LaKfQ4d+aynKmzwd2t3VcPcUVlWHByzI=";
  };

  cargoHash = "sha256-svHEeCcudQ4fXxAcYkz8Y8NJ8ATQacXIWXF1c5shom0=";

  meta = {
    description = "Manage secret values in-repo via public key cryptography";
    homepage = "https://github.com/fpco/amber";
    changelog = "https://github.com/fpco/amber/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
    mainProgram = "amber";
  };
})

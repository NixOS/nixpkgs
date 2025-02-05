{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  # Renaming it to amber-secret because another package named amber exists
  pname = "amber-secret";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "amber";
    rev = "v${version}";
    hash = "sha256-nduSnDhLvHpZD7Y1zeZC4nNL7P1qfLWc0yMpsdqrKHM=";
  };

  cargoHash = "sha256-DxTsbJ51TUMvc/NvsUYhRG9OxxEGrWfEPYCOYaG9PXo=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = {
    description = "Manage secret values in-repo via public key cryptography";
    homepage = "https://github.com/fpco/amber";
    changelog = "https://github.com/fpco/amber/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
    mainProgram = "amber";
  };
}

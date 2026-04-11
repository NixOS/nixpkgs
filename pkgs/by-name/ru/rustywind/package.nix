{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustywind";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qbOlU7kqVbB/sQg4b78CohOwQbraulZ8dRxeT+39rFk=";
  };

  cargoHash = "sha256-eXTdPtcsWhsABZU6kRzZ6eF1VaabouZwLAFI9KpAx98=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for organizing Tailwind CSS classes";
    mainProgram = "rustywind";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})

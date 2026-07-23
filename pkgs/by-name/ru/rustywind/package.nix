{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustywind";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uxgp8cwOswrhDLtx5ZAxsdy96/+UjYhzNKwvt0DBmhk=";
  };

  cargoHash = "sha256-W5dPMSkihxWryLEpQhqt9IpiwyAYSsIgQLbwjnXVjEk=";

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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustywind";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DHZF/ftJqeKvjgaYUY8KNOkq7MBguPi2yXyrb1V91M8=";
  };

  cargoHash = "sha256-A2bD4uXU4/9uMJjCHc83dfFVqjn/zgjZ31gDWiAhFVk=";

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

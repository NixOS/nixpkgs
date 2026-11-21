{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leptosfmt";
  version = "0.1.34";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    tag = finalAttrs.version;
    hash = "sha256-0LLqjIiqP+/VpmGYifjt5wO5Yh7WCM9QkGOpVauveWk=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Qhcj4NBEcD2FG7PRsiwc/cfSUFwObXizDlNPTPHv848=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Formatter for the leptos view! macro";
    mainProgram = "leptosfmt";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})

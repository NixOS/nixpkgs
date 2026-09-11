{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldapin";
  version = "0.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "ldapin";
    tag = finalAttrs.version;
    hash = "sha256-bo0TY9EVIe2etJKeVJBbhYdS7DEe4XgeClkYq8NGDfA=";
  };

  cargoHash = "sha256-0wKHutC6ZXPKQT7ucjZSXd6VbrzrzTlXGjI0ll0ZQvU=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to perform basic LDAP task for security assessments";
    homepage = "https://github.com/affolter-engineering/ldapin";
    changelog = "https://github.com/affolter-engineering/ldapin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ldapin";
  };
})

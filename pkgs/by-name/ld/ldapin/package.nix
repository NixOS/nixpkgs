{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldapin";
  version = "0.1.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "ldapin";
    tag = finalAttrs.version;
    hash = "sha256-XYuGoF3bqp6e8pBj9Se+8xgoHhrhO5ThAq0WzmpTJfY=";
  };

  cargoHash = "sha256-aVRXceO6t7z4FfHu5L/gl2I+LngmFvuQqW7gLoUs1bA=";

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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "similarity";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mizchi";
    repo = "similarity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z2ZaKBpq7N8KIX8nOzPhm8evfoUxBzaAK0+4cU9qBDE=";
  };

  cargoHash = "sha256-oYqdCHGY6OZSbYXhjIt20ZL2JkZP7UEOhn0fhuZQnZo=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.pname}-ts";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Code similarity detection tool";
    homepage = "https://github.com/mizchi/similarity";
    changelog = "https://github.com/mizchi/similarity/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
  };
})

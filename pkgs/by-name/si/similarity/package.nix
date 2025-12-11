{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "similarity";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "mizchi";
    repo = "similarity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eZQ0FTmysFYwqg3sjasZW3S0lps2XbFWUbWuZzkFWkA=";
  };

  cargoHash = "sha256-7qLC1RvjBXd9JFrJdDTIngZhMvyQV1ko3MXRr/2y7hA=";

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

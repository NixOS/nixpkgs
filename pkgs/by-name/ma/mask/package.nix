{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mask";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "jacobdeichert";
    repo = "mask";
    tag = "mask/${finalAttrs.version}";
    hash = "sha256-xGD23pso5iS+9dmfTMNtR6YqUqKnzJTzMl+OnRGpL3g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JaYr6J3NOwVIHzGO4wLkke5O/T/9WUDENPgLP5Fwyhg=";

  # tests require mask to be installed
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^mask/(.*)$" ]; };

  meta = {
    description = "CLI task runner defined by a simple markdown file";
    mainProgram = "mask";
    homepage = "https://github.com/jacobdeichert/mask";
    changelog = "https://github.com/jacobdeichert/mask/blob/mask/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
  };
})

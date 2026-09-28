{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dtop";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "amir20";
    repo = "dtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7APbKhXiqJyb0xAhUou0PfkdZFJvUTb3Ek/94bah7Lg=";
  };

  cargoHash = "sha256-NTFWtlFiHHQoiy3IdGZeVy7q75OvHeZ2LBbY7EKHru8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal dashboard for Docker monitoring across multiple hosts with Dozzle integration";
    homepage = "https://dtop.dev/";
    downloadPage = "https://github.com/amir20/dtop";
    changelog = "https://github.com/amir20/dtop/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "dtop";
  };
})

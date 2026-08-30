{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dtop";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "amir20";
    repo = "dtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xjhtqO6mAP8dJ0oa3ShIiTJNtt6tN/XfJDSBXL8yvqo=";
  };

  cargoHash = "sha256-V7Czo5UUTWiha7I/A8tznsqcDSZGqyDKkYamxDLJZDc=";

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

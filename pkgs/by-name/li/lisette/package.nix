{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  go,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lisette";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ivov";
    repo = "lisette";
    tag = "lisette-v${finalAttrs.version}";
    hash = "sha256-vepiowHDu0l7BCT42ceIEOVaoUd9ttrE21N6D9+zPgo=";
  };

  cargoHash = "sha256-N7Y0BHaVcF8ejKnFrci0KHoy0SLuiTmJpgAPOV8hkAg=";

  preCheck = ''
    export NO_COLOR=true
  '';

  nativeCheckInputs = [
    go
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Little language inspired by Rust that compiles to Go";
    homepage = "https://github.com/ivov/lisette";
    changelog = "https://github.com/ivov/lisette/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "lis";
  };
})

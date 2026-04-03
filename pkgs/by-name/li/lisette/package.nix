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
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ivov";
    repo = "lisette";
    tag = "lisette-v${finalAttrs.version}";
    hash = "sha256-wUd4LjwbsW5hS2VAbzzq9oDDPLbdXie6JmkuOEBsjmA=";
  };

  cargoHash = "sha256-E+8eFfftyrIGNfddQqDmmfPpv1FyYg2u00+KKru+B0Y=";

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

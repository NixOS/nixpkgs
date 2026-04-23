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
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "ivov";
    repo = "lisette";
    tag = "lisette-v${finalAttrs.version}";
    hash = "sha256-PzQQd5tgn3g+Gq0qVe8p9FSbIIpR178fDXvGcwmdcvU=";
  };

  cargoHash = "sha256-3g8Vqr2PydVvp1k7E2fJGrDc1n5OjSQ7Ksl/UKEwWns=";

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

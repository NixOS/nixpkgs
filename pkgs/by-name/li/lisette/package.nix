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
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "ivov";
    repo = "lisette";
    tag = "lisette-v${finalAttrs.version}";
    hash = "sha256-sSNQKVfclSXXt1hp1AVBUKAjLhG9RSKxpoC8zWvOSz4=";
  };

  cargoHash = "sha256-MlRx0lXuGyz7P8DT2tCsxVQ/W5P+W5+8YBt43wTz2IE=";

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

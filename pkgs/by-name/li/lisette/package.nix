{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  go,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lisette";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "ivov";
    repo = "lisette";
    tag = "lisette-v${finalAttrs.version}";
    hash = "sha256-y4daDiPOf5egoAiE1y6vEZoZJfDLB2ywy7hOn75GS/Y=";
  };

  cargoHash = "sha256-ARONSRqGiLF9UC5rJIc6754km7tS+9WQUSMuedRB1Fg=";

  # The e2e_learn test expects to find the `lis` binary in `target/debug/lis`
  postPatch = ''
    substituteInPlace tests/e2e_learn.rs --replace-fail \
      'repo.join("target/debug/lis")' \
      'repo.join("target/${stdenv.hostPlatform.rust.cargoShortTarget}/debug/lis")'
  '';

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

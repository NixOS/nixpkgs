{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonschema-cli";
  version = "0.30.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-AjBVvEixkP7khm3/0U81E/G7tCKoqnfNG05gpgYlqNE=";
  };

  cargoHash = "sha256-3hZAEjJrJ5vw6kXwY+xTv/mO0lx/KNmXA2lULJkX9aE=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast command-line tool for JSON Schema validation";
    homepage = "https://github.com/Stranger6667/jsonschema";
    changelog = "https://github.com/Stranger6667/jsonschema/releases/tag/rust-v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "jsonschema-cli";
  };
}

{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-petname";
  version = "3.2.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "petname";
    hash = "sha256-5uPOgb89boLelqgbnLR9ojT5iouN0Znrujs69X/9mnE=";
  };

  cargoHash = "sha256-Cs0vigT5dbBmqZ0DTwjnxkrQnsmqqA7cLPLYwZzlnH4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "petname";
  };
})

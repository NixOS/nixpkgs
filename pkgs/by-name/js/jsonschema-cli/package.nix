{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonschema-cli";
  version = "0.29.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HHS8dt3bJZ3dPWqB5K0h5KQTn/wHRYvIROfYmqfxolw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RIt+b1Yokc4UMFPxOzO5GARsI32wL71ZmcoN+P/KE5c=";

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

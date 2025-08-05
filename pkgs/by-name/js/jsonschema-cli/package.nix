{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonschema-cli";
  version = "0.32.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZcavZSHf2eT65f7HbtZmD2mYUtrXEL/l1opXCvdn1O0=";
  };

  cargoHash = "sha256-ivD1dvz2xxNei77Dq6myE4zivWD8LZoEqq8E7QhgP9s=";

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

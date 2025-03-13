{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonschema-cli";
  version = "0.29.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-kpdvvCnMsHfogXmAqNeo1Cl1hZtCPHqkfhYm8ipWToo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Yti1KKJDRXMhDo84/ymZk2AkWp9HtU2LW2h63gfzIGY=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = [ "--version" ];

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

{
  lib,
  rustPlatform,
  fetchCrate,
  runCommand,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cocoa-archive";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-4QoGeW3Pk1NNZtD1o00xzp2RZBFiaX+iLW2PhPa6SL4=";
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  cargoHash = "sha256-gDEMQQJn/bgHpviI38BjYqu/r0SRwh9K1m4cC0pQusM=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Generate property list archives for supported macOS Cocoa objects";
    homepage = "https://github.com/kayskayskays/cocoa-archive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kayskayskays ];
    mainProgram = "cocoa-archive";
  };
})

{
  lib,
  fetchCrate,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxvg";
  version = "0.0.9";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-R4Ua+M5/G0Xn+o383WPcbnUOQO2bbL0GEdjIdyk1gLQ=";
  };

  cargoHash = "sha256-RQOWxtXpGfZ25owVQL/IwQx3ndzucXR5IWLIvB8qPfs=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector image toolchain";
    homepage = "https://github.com/noahbald/oxvg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyceherrman ];
    mainProgram = "oxvg";
  };
})

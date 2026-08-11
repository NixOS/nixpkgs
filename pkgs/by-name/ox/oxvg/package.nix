{
  lib,
  fetchCrate,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxvg";
  version = "0.0.6";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-0qi9rNHQHn01aq7rle84GVr2wlAPqb0Xobs0FjSBMh0=";
  };

  cargoHash = "sha256-WEh9/+vl0CtSuD622JSavAYmifYEeWAxCUxLtec9IWM=";

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

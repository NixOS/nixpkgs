{
  lib,
  fetchCrate,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxvg";
  version = "0.0.8";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-eq2cihOJs+F4R+ZCL0k9QoJdW0YjJSNf52vhJzyfLy4=";
  };

  cargoHash = "sha256-SMjNYRCCX4ZqP9vRTNmnVsYVp90l22N9HD05wDDfgZs=";

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

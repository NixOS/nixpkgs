{
  lib,
  fetchCrate,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxvg";
  version = "0.0.7";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-x2xK37GOQOu7tdOmxUxitdpDfEXzfrJveNnbjHCeuvs=";
  };

  cargoHash = "sha256-NYMf4enipgr1dsiJMsSRpWHRi3BVDH92WRmYDOfmXVU=";

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

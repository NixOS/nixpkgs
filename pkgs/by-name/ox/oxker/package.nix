{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxker";
  version = "0.12.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-cTusvvxr2ec2Qy6iWwGRmPcvGpRMOKxzrAx/qRvj+BE=";
  };

  cargoHash = "sha256-X5iNAwp0DcXoT82ZLq37geifztvJ/zZgOgM3SycAazA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple TUI to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siph ];
    mainProgram = "oxker";
  };
})

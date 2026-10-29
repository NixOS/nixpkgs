{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openxr-loader,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "motoc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "motoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XvqI6rwy7AOWjJNojs/nk5RsN/BUVTlx8GACiot0pUY=";
  };

  cargoHash = "sha256-SLNnRXCavAyOqbKvzsG660yTK5Bcff/VM+EQ1K3npng=";

  buildInputs = [
    openxr-loader
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MOnado Tracking Origin Calibration program";
    homepage = "https://github.com/galister/motoc";
    changelog = "https://github.com/galister/motoc/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "motoc";
  };
})

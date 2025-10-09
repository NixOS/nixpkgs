{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openxr-loader,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "motoc";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "motoc";
    tag = "v${version}";
    hash = "sha256-CAKgh9uddDhaFp2O62o1nNZ/ZWJbCR/7dMaI9V992Xk=";
  };

  cargoHash = "sha256-RDzPvHlXuNLv3GiaGSYCyvbhdmxQkjUtwPq/e5NloOg=";

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
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openxr-loader,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "motoc";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "motoc";
    tag = "v${version}";
    hash = "sha256-ozC7Az7G7qGsGURJ6UaM6VZH4PEUTknYDPShtXEKmrA=";
  };

  cargoHash = "sha256-Owv0OTbBpsd6xvadVOu3F3JAmo6SPdwzT3MOAP54nPY=";

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

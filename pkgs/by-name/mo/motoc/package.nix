{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openxr-loader,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "motoc";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "motoc";
    rev = "refs/tags/v${version}";
    hash = "sha256-AmHTnCUTHoeLsOJrD35BooU9mZr5ctoCJmjW5CaTYBY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XaUtlEa71uOlsLrSa2p6tSUnKHfKE3wRQN6ujnAJKPI=";

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

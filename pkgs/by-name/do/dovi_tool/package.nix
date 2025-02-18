{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  fontconfig,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "dovi_tool";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "dovi_tool";
    tag = version;
    hash = "sha256-z783L6gBr9o44moKYZGwymWEMp5ZW7yOhZcpvbznXK4=";
  };

  checkFlags = [
    # fails because nix-store is read only
    "--skip=rpu::plot::plot_p7"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fontconfig
  ];

  passthru.updateScript = nix-update-script { };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pwB6QBLeHALbYZHzTBm/ODLPHhxM3B5n+B/0iXYNuVc=";

  meta = {
    description = "CLI tool combining multiple utilities for working with Dolby Vision";
    homepage = "https://github.com/quietvoid/dovi_tool";
    changelog = "https://github.com/quietvoid/dovi_tool/releases";
    mainProgram = "dovi_tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ plamper ];
  };
}

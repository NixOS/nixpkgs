{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargonode";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "xosnrdev";
    repo = "cargonode";
    tag = version;
    hash = "sha256-O5+wAM99m1rgQpwz36mkHEU/FvGnY6hBCKPMIGXCeCU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dYOdnyKdzL93kuSTUb+1vRqfDgkZLymaEZo9FUrR1JI=";

  checkFlags = [
    # Skip test that requires network access
    "--skip test_download_file"
    "--skip test_extract_zip"
    "--skip test_invalid_download_url"
    "--skip test_create_package"
    "--skip test_init_package"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Unified tooling for Node.js";
    mainProgram = "cargonode";
    homepage = "https://github.com/xosnrdev/cargonode?tab=readme-ov-file#readme";
    changelog = "https://github.com/xosnrdev/cargonode/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ xosnrdev ];
  };
}

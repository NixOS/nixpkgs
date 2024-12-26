{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargonode";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "xosnrdev";
    repo = "cargonode";
    rev = "refs/tags/${version}";
    hash = "sha256-xzBLuQRyKmd9k0sbBFV5amtFWwKqXR0CEsRv8SHiJcQ=";
  };

  cargoHash = "sha256-v+Fs2VJrpnIOk9nPRanYYChlR7WOfkXF1kbYOKjOUYc=";

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
    homepage = "https://github.com/xosnrdev/cargonode";
    changelog = "https://github.com/xosnrdev/cargonode/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ xosnrdev ];
  };
}

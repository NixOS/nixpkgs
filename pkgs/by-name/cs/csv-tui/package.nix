{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "csv-tui";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "nathangavin";
    repo = "csv-tui";
    rev = "v${version}";
    hash = "sha256-IRXLwZ2FHcCDmDVJ0xnV/4q+X2AFXPX/+Ph4Xxo3DyM=";
  };

  cargoHash = "sha256-wgeVcX0zSXffAuvKw2eKXC846WlC8F9UGMoxP3IXoLE=";

  meta = {
    description = "Terminal based csv editor which is designed to be memory efficient but still useful";
    homepage = "https://github.com/nathangavin/csv-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ottoblep ];
    mainProgram = "csv_tui";
  };
}

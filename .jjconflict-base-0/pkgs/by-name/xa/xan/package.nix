{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "xan";
  version = "0.49.3";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = version;
    hash = "sha256-2BEwMpI9vmhyZFZiEj8sHnVqCYGBULFORGxZgxdmr7M=";
  };

  cargoHash = "sha256-spKgZ8T94zhLIDhym5wQrhnW74KPgCMy5Y+3m/pX9/o=";
  useFetchCargoVendor = true;

  # FIXME: tests fail and I do not have the time to investigate. Temporarily disable
  # tests so that we can manually run and test the package for packaging purposes.
  doCheck = false;

  meta = {
    description = "Command line tool to process CSV files directly from the shell";
    homepage = "https://github.com/medialab/xan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "xan";
  };
}

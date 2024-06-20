{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-7UMHkm3AtPqUILrsUnM0SbZT4Sq55dEElMN0KonjwtE=";
  };

  cargoHash = "sha256-CtEirsSQAg2Fv44YoKKmSjQs85++QWFRcWoA4VrBbgU=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}

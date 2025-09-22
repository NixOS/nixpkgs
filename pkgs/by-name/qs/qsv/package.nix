{
  fetchFromGitHub,
  file,
  lib,
  pkg-config,
  rustPlatform,
  sqlite,
  zstd,
  cmake,
}:

let
  pname = "qsv";
  version = "7.1.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dathere";
    repo = "qsv";
    rev = version;
    hash = "sha256-jo5hlNydHXNqSjYOC270fmIk7GOeFACIZ3aZEca1M28=";
  };

  cargoHash = "sha256-jfr5wrOLBhvkikjDAb0vMT/Zwc+aYrSWF5lIC7EGwME=";

  buildInputs = [
    file
    sqlite
    zstd
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    cmake
  ];

  buildFeatures = [
    "apply"
    "feature_capable"
    "fetch"
    "foreach"
    "geocode"
    "to"
  ];

  checkFeatures = [
    "apply"
    "feature_capable"
    "fetch"
    "foreach"
    "geocode"
  ];

  doCheck = false;

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "CSVs sliced, diced & analyzed";
    homepage = "https://github.com/dathere/qsv";
    changelog = "https://github.com/dathere/qsv/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      # or
      unlicense
    ];
    maintainers = with lib.maintainers; [
      detroyejr
    ];
  };
}

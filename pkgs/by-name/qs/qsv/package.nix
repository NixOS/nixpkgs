{
  fetchFromGitHub,
  file,
  lib,
  pkg-config,
  rustPlatform,
  sqlite,
  stdenv,
  zstd,
}:

let
  pname = "qsv";
  version = "2.2.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dathere";
    repo = "qsv";
    rev = version;
    hash = "sha256-LE3iQCZb3FKSsrb8/E5awjh26wGv9FlXw63+rNyzIIk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Nse3IrhXKdEJ3BMWq8LEdd6EvhSEtzx1RbHQT9AoEb8=";

  buildInputs = [
    file
    sqlite
    zstd
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
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
      uncenter
    ];
  };
}

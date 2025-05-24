{
  stdenv,
  fetchFromGitHub,
  file,
  lib,
  pkg-config,
  rustPlatform,
  sqlite,
  zstd,
  cmake,
  python3,
  withPolars ? true,
  withPython ? stdenv.buildPlatform == stdenv.hostPlatform,
  buildFeatures ?
    # enable all features except self_update by default
    # https://github.com/dathere/qsv/blob/4.0.0/Cargo.toml#L356
    [
      "apply"
      "feature_capable"
      "fetch"
      "foreach"
      "geocode"
      "luau"
      "to"
      "ui"
    ]
    ++ lib.optional withPolars "polars"
    ++ lib.optional withPython "python",
  pname ? "qsv",
}:

let
  version = "4.0.0";
in
rustPlatform.buildRustPackage {
  inherit pname version buildFeatures;

  src = fetchFromGitHub {
    owner = "dathere";
    repo = "qsv";
    rev = version;
    hash = "sha256-rMqDn2Dw64xxAVE3ZslKzpyNfgRMrLIALHjVtcq0vqU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/hkFIM7grcyMYNdM5UP2Mx+hBuw7zk8R2KbUYp2UkTg=";

  buildInputs = [
    file
    sqlite
    zstd
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    cmake
  ] ++ lib.optional (lib.elem "python" buildFeatures) python3;

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
    mainProgram = pname;
    maintainers = with lib.maintainers; [
      detroyejr
      misuzu
    ];
  };
}

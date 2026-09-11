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
  wayland,
  withPolars ? true,
  withPython ? stdenv.buildPlatform == stdenv.hostPlatform,
  withUi ? true,
  buildFeatures ?
    # enable all features except self_update by default
    # https://github.com/dathere/qsv/blob/19.1.0/Cargo.toml#L370
    [
      "apply"
      "feature_capable"
      "fetch"
      "foreach"
      "geocode"
      "luau"
      "to"
    ]
    ++ lib.optional withPolars "polars"
    ++ lib.optional withPython "python"
    ++ lib.optional withUi "ui",
  mainProgram ? "qsv",
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qsv";
  version = "22.0.1";

  inherit buildFeatures;

  src = fetchFromGitHub {
    owner = "dathere";
    repo = "qsv";
    rev = finalAttrs.version;
    hash = "sha256-lZ1iC+lnPgJqcKV9RDia/ndVBJjWUV8Z3L6k9hjAe3M=";
  };

  cargoHash = "sha256-QdNOXmTIZ5CF73u1fMkkVa+ulUfD/looiBvbiM9TBfo=";

  buildInputs = [
    file
    sqlite
    zstd
  ]
  ++ lib.optional (lib.elem "ui" buildFeatures && stdenv.hostPlatform.isLinux) wayland;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    cmake
  ]
  ++ lib.optional (lib.elem "python" buildFeatures) python3;

  doCheck = false;

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "CSVs sliced, diced & analyzed";
    homepage = "https://github.com/dathere/qsv";
    changelog = "https://github.com/dathere/qsv/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      # or
      unlicense
    ];
    inherit mainProgram;
    maintainers = with lib.maintainers; [
      detroyejr
      misuzu
    ];
  };
})

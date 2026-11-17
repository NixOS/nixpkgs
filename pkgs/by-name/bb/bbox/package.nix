{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  protobuf,

  sqlite,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bbox";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "bbox-services";
    repo = "bbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FmY9Hqwv9lWjdEMe4JZM/nw8BaeZ+4eK+nibOUwcE+8=";
  };

  __structuredAttrs = true;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pmtiles-0.12.0" = "sha256-wy22X51TcQOFxdXOInQxoL8DtFPqtV3pE0pQaEehtCA=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    sqlite
    zstd
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  cargoBuildFlags = [
    # server including all features
    "--package bbox-server"
  ];

  cargoTestFlags = [ "--workspace" ];

  meta = {
    description = "Composable spatial services";
    homepage = "https://www.bbox.earth/";
    downloadPage = "https://github.com/bbox-services/bbox/";
    changelog = "https://github.com/bbox-services/bbox/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      # or
      mit
    ];
    teams = [ lib.teams.geospatial ];
    mainProgram = "bbox-server";
  };
})

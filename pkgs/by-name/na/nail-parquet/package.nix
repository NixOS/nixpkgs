{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  nail-parquet,
  stdenv,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nail-parquet";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "Vitruves";
    repo = "nail-parquet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IDGVdC4jvDfFTP0N0LAi8MTGdUOCT6A7mKXIz2au6jY=";
  };

  cargoHash = "sha256-c4yuXCQAlwpDlKURwN51d3AI+m7cUNGRdgl29qgWIvA=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = nail-parquet;
      command = "nail --version";
    };
  };

  meta = {
    description = "High-performance command-line utility for working with Parquet files";
    homepage = "https://github.com/Vitruves/nail-parquet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nathanscully ];
    mainProgram = "nail";
  };
})

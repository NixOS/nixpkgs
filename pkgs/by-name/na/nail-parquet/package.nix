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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Vitruves";
    repo = "nail-parquet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oY+C1knZRBvZR/4mjq3wv6ZntD6+tLJFfplRBoAkds0=";
  };

  cargoHash = "sha256-cPRbQBxUL+5z1Hi6asXMKb8NPxNjmc+3gIa5ZKEmqWM=";

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

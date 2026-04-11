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
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "Vitruves";
    repo = "nail-parquet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CPiOeaESerQj+nV0hQIGv06/MFP8s7p9olpmhnWpAAg=";
  };

  cargoHash = "sha256-x4BJZcQkisw9hA/TBzSSdkxh7oUNL0OD3H/v67otYj8=";

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

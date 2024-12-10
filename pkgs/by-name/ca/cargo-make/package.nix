{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.37.12";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = "cargo-make";
    rev = version;
    hash = "sha256-hnjhc4ZIabHml0HMuIanwXkx+QGnal7RlvZjcZUx8pQ=";
  };

  cargoHash = "sha256-5Z8ywbaWVgLx6PH/w9QV0LJpeqY7zpkCqnAb4BAww0o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      bzip2
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with lib; {
    description = "A Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    changelog = "https://github.com/sagiegurari/cargo-make/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-make";
  };
}

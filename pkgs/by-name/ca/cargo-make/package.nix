{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.37.13";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = "cargo-make";
    rev = version;
    hash = "sha256-5A0J3NtxXlhIhr0+GZoctCA5EwTnBt+9aL4I8HUiJqY=";
  };

  cargoHash = "sha256-7UA9EOUF/A1FhWBErZdPrzL+rDukjbtC2KIK10cLDXI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with lib; {
    description = "Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    changelog = "https://github.com/sagiegurari/cargo-make/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-make";
  };
}

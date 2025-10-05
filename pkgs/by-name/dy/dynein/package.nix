{
  fetchFromGitHub,
  lib,
  cmake,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dynein";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "dynein";
    rev = "v${version}";
    hash = "sha256-GU/zZ7IJPfpRbrWjrVwPDSFjFfMLoG/c8DDWlN6nZ94=";
  };

  # Use system openssl.
  OPENSSL_NO_VENDOR = 1;

  cargoHash = "sha256-PA7Hvn+vYBD80thkIamwOhw4lJWAmU/TQBnwJro4r7c=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    cmake
  ];

  preBuild = ''
    export CMAKE=${lib.getDev cmake}/bin/cmake
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib
  '';

  # The integration tests will start downloading docker image of DynamoDB, which
  # will naturally fail for nix build. The CLI tests do not need DynamoDB.
  cargoTestFlags = [ "cli_tests" ];

  meta = with lib; {
    description = "DynamoDB CLI written in Rust";
    mainProgram = "dy";
    homepage = "https://github.com/awslabs/dynein";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}

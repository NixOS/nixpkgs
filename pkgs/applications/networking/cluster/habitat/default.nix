{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  libsodium,
  openssl,
  xz,
  zeromq,
  cacert,
}:

rustPlatform.buildRustPackage rec {
  pname = "habitat";
  version = "1.6.848";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    hash = "sha256-oK9ZzENwpEq6W1qnhSgkr7Rhy7Fxt/BS4U5nxecyPu8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "clap-2.33.1" = "sha256-ixyNr91VNB2ce2cIr0CdPmvKYRlckhKLeaSbqxouIAY=";
      "configopt-0.1.0" = "sha256-76MeSoRD796ZzBqX3CoDJnunekVo2XfctpxrpspxmAU=";
      "rants-0.6.0" = "sha256-B8uDoiqddCki3j7aC8kilEcmJjvB4ICjZjjTun2UEkY=";
      "retry-1.0.0" = "sha256-ZaHnzOCelV4V0+MTIbH3DXxdz8QZVgcMq2YeV0S6X6o=";
      "structopt-0.3.15" = "sha256-0vIX7J7VktKytT3ZnOm45qPRMHDkdJg20eU6pZBIH+Q=";
      "zmq-0.9.2" = "sha256-bsDCPYLb9hUr6htPQ7rSoasKAqoWBx5FiEY1gOOtdJQ=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    libsodium
    openssl
    xz
    zeromq
  ];

  cargoBuildFlags = [
    "-p"
    "hab"
  ];
  cargoTestFlags = cargoBuildFlags;

  env = {
    OPENSSL_NO_VENDOR = true;
    SODIUM_USE_PKG_CONFIG = true;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  meta = with lib; {
    description = "An application automation framework";
    homepage = "https://www.habitat.sh";
    changelog = "https://github.com/habitat-sh/habitat/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rushmorem
      qjoly
    ];
    mainProgram = "hab";
    platforms = [ "x86_64-linux" ];
  };
}

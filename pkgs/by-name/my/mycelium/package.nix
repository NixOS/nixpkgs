{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mycelium";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "threefoldtech";
    repo = "mycelium";
    rev = "v${version}";
    hash = "sha256-Mz4YYpnuSGUwQANiXzsJNAYMugXL229E30wnZCu2lSM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tun-0.6.1" = "sha256-DelNPCOWvVSMS2BNGA2Gw/Mn9c7RdFNR21/jo1xf+xk=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  meta = with lib; {
    description = "End-2-end encrypted IPv6 overlay network";
    homepage = "https://github.com/threefoldtech/mycelium";
    changelog = "https://github.com/threefoldtech/mycelium/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli matthewcroughan ];
    mainProgram = "mycelium";
  };
}

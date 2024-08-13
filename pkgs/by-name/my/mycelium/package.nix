{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, openssl
, darwin
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "mycelium";
  version = "0.5.3";

  sourceRoot = "${src.name}/myceliumd";

  src = fetchFromGitHub {
    owner = "threefoldtech";
    repo = "mycelium";
    rev = "v${version}";
    hash = "sha256-nyHHuwOHaIh8WCxaQb7QoTReV09ydhHLYwEVHQg2Hek=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tun-0.6.1" = "sha256-tJx/qRwPcZOAfxyjZUHKLKsLu+loltVUOCP8IzWMryM=";
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

  passthru.tests = { inherit (nixosTests) mycelium; };

  meta = with lib; {
    description = "End-2-end encrypted IPv6 overlay network";
    homepage = "https://github.com/threefoldtech/mycelium";
    changelog = "https://github.com/threefoldtech/mycelium/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli matthewcroughan ];
    mainProgram = "mycelium";
  };
}

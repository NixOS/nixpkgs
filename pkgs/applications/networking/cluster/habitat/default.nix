{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, perl
, libsodium
, libarchive
, openssl
, zeromq
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "habitat";
  version = "1.6.614";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    sha256 = "17yVH750pNfpBM+3t1IGuZcslyfFeKDZ+9dLbOt8Rs0=";
  };

  cargoSha256 = "14b6sV2QjlEqbDsJwnfbyRVUbeskacq39cSR1blYBrg=";

  nativeBuildInputs = [
    pkg-config
    perl # used by openssl-sys to configure
  ];

  buildInputs = [
    libarchive
    openssl
    zeromq
    protobuf
  ];

  preBuild = ''
    export PROTOC=${protobuf}/bin/protoc
    export PROTOC_INCLUDE="${protobuf}/include";
  '';

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoBuildFlags = [ "--package hab" ];

  # the test suite calls out to the public internet and tries to install busybox-static in multiple places
  doCheck = false;

  meta = with lib; {
    description = "An application automation framework";
    homepage = "https://www.habitat.sh";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem ];
  };
}

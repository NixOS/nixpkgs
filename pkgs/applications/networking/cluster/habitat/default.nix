{ lib, fetchFromGitHub, rustPlatform, pkg-config
, libsodium, libarchive, openssl, zeromq }:

rustPlatform.buildRustPackage rec {
  pname = "habitat";
  # Newer versions required protobuf, which requires some finesse to get to
  # compile with the vendored protobuf crate.
  version = "0.90.6";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    sha256 = "0rwi0lkmhlq4i8fba3s9nd9ajhz2dqxzkgfp5i8y0rvbfmhmfd6b";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ipc-channel-0.9.0" = "sha256-ZinW3vTsb6dWDRN1/P4TlOlbjiQSHkE6n6f1yEiKsbA=";
      "nats-0.3.2" = "sha256-ebZSSczF76FMsYRC9hc4n9yTQVyAD4JgaqpFvGG+01U=";
      "zmq-0.8.3" = "sha256-ZydP7ThHvLMWc8snm52Wlhji35Gn5Y2TzzN75UH5xLE=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsodium libarchive openssl zeromq ];

  cargoBuildFlags = ["--package hab"];

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    cargo test --package hab
    runHook postCheck
  '';

  meta = with lib; {
    description = "An application automation framework";
    homepage = "https://www.habitat.sh";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem ];
    platforms = [ "x86_64-linux" ];
  };
}

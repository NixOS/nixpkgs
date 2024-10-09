{
  lib,
  stdenv,
  darwin,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-udp-forwarder";
  version = "4.1.8";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-udp-forwarder";
    rev = "v${version}";
    hash = "sha256-Snj5nKyFsq8WJJNw1d8O/YX/dZ/tCTVBw5R8kXJvsa4=";
  };

  cargoHash = "sha256-7ugrIVT4SYrqPqF0CrLU+/Ep/p9H7/on3hkZ5JzY9AE=";

  nativeBuildInputs = [ protobuf ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "UDP packet-forwarder for the ChirpStack Concentratord";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-udp-forwarder";
  };
}

{
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  lib,
}:

rustPlatform.buildRustPackage {
  pname = "grpc-health-check";
  version = "unstable-2022-08-19";

  src = fetchFromGitHub {
    owner = "paypizza";
    repo = "grpc-health-check";
    rev = "f61bb5e10beadc5ed53144cc540d66e19fc510bd";
    hash = "sha256-nKut9c1HHIacdRcmvlXe0GrtkgCWN6sxJ4ImO0CIDdo=";
  };

  cargoHash = "sha256-NdwQ9gctO0Thaes2T5E9lo6dZ00+FoA3IO553g+NJh0=";

  nativeBuildInputs = [ protobuf ];
  # tests fail
  doCheck = false;

  meta = {
    description = "Minimal, high performance, memory-friendly, safe implementation of the gRPC health checking protocol";
    homepage = "https://github.com/paypizza/grpc-health-check";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ flokli ];
    platforms = lib.platforms.unix;
  };
}

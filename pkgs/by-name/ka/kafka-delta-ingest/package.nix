{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  perl,
  rdkafka,
  # these are features in the cargo, where one may be disabled to reduce the final size
  enableS3 ? true,
  enableAzure ? true,
}:

assert lib.assertMsg (enableS3 || enableAzure) "Either S3 or azure support needs to be enabled";
rustPlatform.buildRustPackage {
  pname = "kafka-delta-ingest";
  version = "0-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "delta-io";
    repo = "kafka-delta-ingest";
    rev = "da9c932be3a98649da74ed91f5e1593bece65e89";
    hash = "sha256-omeIuvi2OEU4jBWbE/EEM/nqHr25sy2+5Q9qsXzZh8E=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildFeatures = [
    "dynamic-linking"
  ]
  ++ lib.optional enableS3 "s3"
  ++ lib.optional enableAzure "azure";

  buildInputs = [
    openssl
    rdkafka
  ];

  # #![deny(warnings)] breaks the build when newer rustc emits new lints.
  env.RUSTFLAGS = "--cap-lints warn";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # many tests seem to require a running kafka instance
  doCheck = false;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Highly efficient daemon for streaming data from Kafka into Delta Lake";
    mainProgram = "kafka-delta-ingest";
    homepage = "https://github.com/delta-io/kafka-delta-ingest";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

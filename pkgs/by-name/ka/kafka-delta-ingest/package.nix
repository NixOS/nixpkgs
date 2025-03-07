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
  version = "0-unstable-2024-11-05";

  src = fetchFromGitHub {
    owner = "delta-io";
    repo = "kafka-delta-ingest";
    rev = "b7638eda8642985b5bd56741de526ea051d784c0";
    hash = "sha256-fngPFvCxEaHVenySG5FBbVXporu3Hf957iV3rGWsrzE=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildFeatures =
    [
      "dynamic-linking"
    ]
    ++ lib.optional enableS3 "s3"
    ++ lib.optional enableAzure "azure";

  buildInputs = [
    openssl
    rdkafka
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # many tests seem to require a running kafka instance
  doCheck = false;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Highly efficient daemon for streaming data from Kafka into Delta Lake";
    mainProgram = "kafka-delta-ingest";
    homepage = "https://github.com/delta-io/kafka-delta-ingest";
    license = licenses.asl20;
    maintainers = [ ];
  };
}

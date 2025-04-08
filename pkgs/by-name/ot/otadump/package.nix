{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  protobuf,
  xz,
}:

rustPlatform.buildRustPackage rec {
  pname = "otadump";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "crazystylus";
    repo = "otadump";
    rev = version;
    hash = "sha256-4zPVcTU+0otV4EPQi80uSRkpRo9XzI0V3Kr17ugXX2U=";
  };

  patches = [ ./no-static.patch ];

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [ xz ];

  doCheck = false; # There are no tests

  useFetchCargoVendor = true;
  cargoHash = "sha256-6L1FJWEaDBqpJvj9uGjYuAqqDoQlkVwOWfbG46Amkkw=";

  meta = {
    description = "Command-line tool to extract partitions from Android OTA files";
    homepage = "https://github.com/crazystylus/otadump";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.axka ];
    mainProgram = "otadump";
  };
}

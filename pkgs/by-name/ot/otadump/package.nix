{ lib, fetchFromGitHub, rustPlatform, pkg-config, protobuf, lzma }:

rustPlatform.buildRustPackage rec {
  pname = "otadump";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "crazystylus";
    repo = pname;
    rev = version;
    hash = "sha256-4zPVcTU+0otV4EPQi80uSRkpRo9XzI0V3Kr17ugXX2U=";
  };

  patches = [ ./no-static.patch ];

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    lzma.dev
  ];

  doCheck = false; # There are no tests

  cargoHash = "sha256-lTzEgy9mevkmefvTZT9hEBHN5I+kXVqTev5+sy/JoaE=";

  meta = {
    description = "Command-line tool to extract partitions from Android OTA files";
    homepage = "https://github.com/crazystylus/otadump";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.axka ];
  };
}

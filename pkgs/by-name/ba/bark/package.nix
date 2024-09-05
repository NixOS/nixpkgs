{
  alsa-lib,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libopus,
  pkg-config,
  rustPlatform,
  soxr,
}:
rustPlatform.buildRustPackage (final: {
  pname = "bark";
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "haileys";
    repo = "bark";
    rev = "v${final.version}";
    hash = "sha256-JaUIWGCYhasM0DgqL+DiG2rE1OWVg/N66my/4RWDN1E=";
  };

  useFetchCargoVendor = true;
  # cargo.lock contains git dependencies (soxr) which we have to specify the hash for.
  # Fix this post v0.6.0 when soxr is published to crates.io
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "soxr-0.0.0" = "sha256-dizttu5GhC1otLlQHU81NymC1a9cQf8hFR0oI+SPqkM=";
    };
  };

  # Broken rustdoc comment
  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/haileys/bark/pull/13.patch";
      hash = "sha256-cA1bqc7XhJ2cxOYvjIJ9oopzBZ9I4rGERkiwDAUh3V4";
    })
  ];

  buildInputs = [
    alsa-lib
    libopus
    soxr
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "Live sync audio streaming for local networks";
    homepage = "https://github.com/haileys/bark";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.linux;
    mainProgram = "bark";
  };
})

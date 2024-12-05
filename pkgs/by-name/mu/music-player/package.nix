{
  lib,
  stdenv,
  alsa-lib,
  darwin,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "music-player";
  version = "0.2.0-alpha.14-unstable-2024-10-02";

  src = fetchFromGitHub {
    owner = "tsirysndr";
    repo = "music-player";
    rev = "cbf03c3f2f0f9baca831b08ec27d9b31438faa3d";
    hash = "sha256-BG0MU6IdFQX+C4BxTZlq5I7a4BQmUTvwAQALw5/UPBE=";
  };

  cargoHash = "sha256-t/jdVTdmaJk8Sb43XEuVCKa4kSR+ZrIEmMQKWeVpB70=";

  nativeBuildInputs =
    [
      protobuf
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pkg-config
    ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AudioUnit
    ];

  meta = {
    description = "Extensible music player daemon written in Rust";
    homepage = "https://github.com/tsirysndr/music-player";
    changelog = "https://github.com/tsirysndr/music-player/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmasquadron ];
    mainProgram = "music-player";
  };
}

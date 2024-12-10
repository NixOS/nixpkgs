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
  version = "0.2.0-alpha.14";

  src = fetchFromGitHub {
    owner = "tsirysndr";
    repo = "music-player";
    rev = "v${version}";
    hash = "sha256-l8Y1fc5v0YDm87b+d3DuMgKFiem6WFfJEASplHoqva0=";
  };

  cargoHash = "sha256-nnOHuAn+eGf+iiX3QbDTH4zHMQ6KV4QP6RnyBhLMrEc=";

  nativeBuildInputs =
    [
      protobuf
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals stdenv.isLinux [
      pkg-config
    ];

  buildInputs =
    lib.optionals stdenv.isLinux [
      alsa-lib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AudioUnit
    ];

  meta = with lib; {
    description = "An extensible music player daemon written in Rust";
    homepage = "https://github.com/tsirysndr/music-player";
    changelog = "https://github.com/tsirysndr/music-player/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "music-player";
  };
}

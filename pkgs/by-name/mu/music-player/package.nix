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
  version = "0.2.0-alpha.14-unstable-2024-08-24";

  src = fetchFromGitHub {
    owner = "tsirysndr";
    repo = "music-player";
    # No patch for 0.2.0, diff patch has a big size, temporarily until the next release
    rev = "cf01ae4d2dcf5c804559250f2c7f922d870ae26d";
    hash = "sha256-8C8uFnXSBalLD2MUgzzfg4ylvTVecyPJOSUri5jbvkM=";
  };

  cargoHash = "sha256-JmyuA5p6/7jtNuOMWuAuspYYid+dGOeollIlS0DRCIE=";

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
    description = "Extensible music player daemon written in Rust";
    homepage = "https://github.com/tsirysndr/music-player";
    changelog = "https://github.com/tsirysndr/music-player/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "music-player";
  };
}

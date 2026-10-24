{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
  zstd,
  alsa-lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "music-player";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "tsirysndr";
    repo = "music-player";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZcLDw9+bH3Iu3zdIyFdlIeAQfsnySDnfeJoHr2yViuA=";
  };

  cargoHash = "sha256-W5VWyXDleZYm+w0yDRTHfRuZjvA2gsXn1eE0UQYg77A=";

  cargoBuildFlags = [
    "--package"
    "music-player"
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    openssl
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  doCheck = false;

  meta = {
    description = "Extensible music player daemon written in Rust";
    homepage = "https://github.com/tsirysndr/music-player";
    changelog = "https://github.com/tsirysndr/music-player/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tsirysndr ];
    mainProgram = "music-player";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

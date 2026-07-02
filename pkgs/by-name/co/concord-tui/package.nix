{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  cmake,
  opus,
  lib,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "concord-tui";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WSZsN1+ZhFWTHl9BvKERrr0lQj06N392Jo2nYjNm5QY=";
  };

  cargoHash = "sha256-LJnwO9507nLptKARCih58+wKrHzLGu+qQ/guf1oezX8=";

  buildInputs = [
    opus
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];
  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  __darwinAllowLocalNetworking = true;

  __structuredAttrs = true;

  meta = {
    description = "Feature-rich TUI client for Discord, written in Rust";
    homepage = "https://github.com/chojs23/concord";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Simon-Weij ];
    mainProgram = "concord";
  };
})

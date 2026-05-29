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
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oKaP5ff19RYg73LsilD1Hxaz7nSr8QK/08jM1TylbWU=";
  };

  cargoHash = "sha256-jJkAXzmZAUHLIO2uVeR3KNTBYAnp31m49mk66/lKHHY=";

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

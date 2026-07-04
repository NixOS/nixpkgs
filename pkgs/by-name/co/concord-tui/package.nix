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
  version = "2.2.12";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oohoQIShX6zZC4fEPQnkvJVqhJSmU21ZrbfN9bDTnQI=";
  };

  cargoHash = "sha256-TFjph7qSc3dHaMRUC7kUwvblfB8zdyvcMT16aHFm8wo=";

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
    maintainers = with lib.maintainers; [
      Simon-Weij
      neo
    ];
    mainProgram = "concord";
  };
})

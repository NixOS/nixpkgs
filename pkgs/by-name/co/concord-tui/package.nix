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
  version = "2.2.13";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Acffg3ExqdcqsMJyv1N74Ff1/NrA1gtw8Tpa3KM4r0=";
  };

  cargoHash = "sha256-CDU9ajRleP/Hr/9DA+8rr+uzv8V3xR9Ki1qtBHhYSpc=";

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

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  vulkan-loader,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "demucs-rs";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "nikhilunni";
    repo = "demucs-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g3na57S/rggHKUvA/bQ3ae2pw/p2ZfJFMTcmf+RkbQs=";
  };

  cargoHash = "sha256-Hw97AURk/sP+FW5qL4NkweRTQuS+VubhXmzNR74rkMc=";

  # Only build the CLI crate, not the DAW plugin or WASM targets
  buildAndTestSubdir = "demucs-cli";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    vulkan-loader
  ];

  # The GPU backends (Vulkan on Linux/Windows, Metal on macOS) require
  # runtime libraries. On Linux, vulkan-loader must be available at runtime.
  # Model weights are downloaded automatically from Hugging Face on first use.

  meta = {
    description = "Native Rust implementation of HTDemucs v4 music source separation CLI";
    longDescription = ''
      A native Rust implementation of HTDemucs v4 — state-of-the-art music
      source separation. Splits any song into individual stems (drums, bass,
      vocals, etc.) using GPU-accelerated inference via Burn.

      Model weights are downloaded automatically from Hugging Face on first
      use and cached for future runs.
    '';
    homepage = "https://github.com/nikhilunni/demucs-rs";
    license = lib.licenses.asl20;
    mainProgram = "demucs";
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.unix;
  };
})

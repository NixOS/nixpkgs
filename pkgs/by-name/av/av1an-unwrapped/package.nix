{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  libaom,
  nasm,
  nix-update-script,
  pkg-config,
  rav1e,
  rustPlatform,
  vapoursynth,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "av1an-unwrapped";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "rust-av";
    repo = "Av1an";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JwYnDl9ZSSE+dD+ZAxuN7ywqFN314Ib/9Flh52kL3do=";
  };

  cargoHash = "sha256-mxWYXujwp7tYAj9bM/ZhqbyISMjvX+AYG07otcB67pg=";

  nativeBuildInputs = [
    nasm
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
    vapoursynth
  ];

  nativeCheckInputs = [
    libaom
    rav1e
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d*\\.\\d*\\.\\d*)$"
      ];
    };
  };

  meta = {
    description = "Cross-platform command-line encoding framework";
    longDescription = ''
      Cross-platform command-line AV1 / VP9 / HEVC / H264 encoding framework with per scene quality encoding.
      It can increase your encoding speed and improve cpu utilization by running multiple encoder processes in parallel.
    '';
    homepage = "https://github.com/rust-av/Av1an";
    changelog = "https://github.com/rust-av/Av1an/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "av1an";
    # symbol index out of range file '/private/tmp/nix-build-av1an-unwrapped-0.4.4.drv-0/rustcz0anL2/librav1e-ca440893f9248a14.rlib' for architecture x86_64
    broken = stdenv.hostPlatform.system == "x86_64-darwin";
  };
})

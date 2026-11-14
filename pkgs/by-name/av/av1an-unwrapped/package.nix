{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg_7,
  libaom,
  libgit2,
  nasm,
  nix-update-script,
  pkg-config,
  rav1e,
  rustPlatform,
  python3Packages,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "av1an-unwrapped";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rust-av";
    repo = "Av1an";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eNkQdeBksjoJEkNwWEd8LtBSxvdinEhJgK1AaO4BntE=";
  };

  cargoHash = "sha256-YMLkoG8RFUpUPqmZKOCWymUxmejEzU+3hslclOYMfes=";

  nativeBuildInputs = [
    nasm
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg_7
    libgit2
    python3Packages.vapoursynth
  ];

  nativeCheckInputs = [
    libaom.bin
    rav1e
    versionCheckHook
  ];

  # The encode_tests integration suite drives the full encode pipeline
  # (external encoders, ffmpeg and vapoursynth source plugins at
  # runtime) and only passes in upstream's prebuilt CI image, so limit
  # the check phase to the unit tests.
  cargoTestFlags = [
    "--workspace"
    "--lib"
    "--bins"
  ];

  # These unit tests load blank_1080p.mkv via core.lsmas.LWLibavSource,
  # which needs the L-SMASH Works plugin.
  checkFlags = [
    "--skip=chunk::tests::apply_photon_noise_args_with_noise"
    "--skip=scenes::tests::validate_zones_target_quality"
    "--skip=encoder::tests::ffmpeg_probe_uses_fps_mode_passthrough"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform command-line encoding framework";
    longDescription = ''
      Cross-platform command-line AV1 / VP9 / HEVC / H264 encoding framework with per scene quality encoding.
      It can increase your encoding speed and improve cpu utilization by running multiple encoder processes in parallel.
    '';
    homepage = "https://github.com/rust-av/Av1an";
    changelog = "https://github.com/rust-av/Av1an/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "av1an";
  };
})

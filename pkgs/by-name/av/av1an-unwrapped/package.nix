{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ffmpeg,
  nasm,
  vapoursynth,
  libaom,
  rav1e,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "av1an-unwrapped";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "master-of-zen";
    repo = "av1an";
    rev = version;
    hash = "sha256-A4/1UdM8N5CHP44PBNB+ZH2Gcl84rcpUBwQRSnubBGc=";
  };

  cargoPatches = [
    # TODO: Remove next release
    # Updates the `time` crate to work around
    # https://github.com/NixOS/nixpkgs/issues/332957
    ./rust-1.80.0.patch
  ];

  cargoHash = "sha256-Obq4oRXZ7IHDT+B9gKrVflq/FDzoN7ttZi8Aj2uOGxM=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    nasm
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
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross-platform command-line encoding framework";
    longDescription = ''
      Cross-platform command-line AV1 / VP9 / HEVC / H264 encoding framework with per scene quality encoding.
      It can increase your encoding speed and improve cpu utilization by running multiple encoder processes in parallel.
    '';
    homepage = "https://github.com/master-of-zen/Av1an";
    changelog = "https://github.com/master-of-zen/Av1an/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "av1an";
  };
}

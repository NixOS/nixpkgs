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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "master-of-zen";
    repo = "av1an";
    rev = "refs/tags/${version}";
    hash = "sha256-Mb5I+9IBwpfmK1w4LstNHI/qsJKlCuRxgSUiqpwUqF0=";
  };

  cargoHash = "sha256-IWcSaJoakXSPIdycWIikGSmOk+D4A3aMnJwuiKn8XNY=";

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
        "'^(\d*\.\d*\.\d*)$'"
      ];
    };
  };

  meta = {
    description = "Cross-platform command-line encoding framework";
    longDescription = ''
      Cross-platform command-line AV1 / VP9 / HEVC / H264 encoding framework with per scene quality encoding.
      It can increase your encoding speed and improve cpu utilization by running multiple encoder processes in parallel.
    '';
    homepage = "https://github.com/master-of-zen/Av1an";
    changelog = "https://github.com/master-of-zen/Av1an/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "av1an";
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  av1an-unwrapped,
  pkg-config,
  ffmpeg,
  nasm,
  vapoursynth,
  libaom,
  rav1e,
}:
rustPlatform.buildRustPackage {
  pname = "av1an-unwrapped";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "master-of-zen";
    repo = "av1an";
    rev = av1an-unwrapped.version;
    hash = "sha256-A4/1UdM8N5CHP44PBNB+ZH2Gcl84rcpUBwQRSnubBGc=";
  };

  cargoHash = "sha256-ahoiCAUREtXgXLNrWVQ2Gc65bWMo4pIJXP9xjnQAlaI=";

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

  meta = with lib; {
    mainProgram = "av1an";
    homepage = "https://github.com/master-of-zen/Av1an";
    description = "Cross-platform command-line encoding framework";
    longDescription = ''
      Cross-platform command-line AV1 / VP9 / HEVC / H264 encoding framework with per scene quality encoding.
      It can increase your encoding speed and improve cpu utilization by running multiple encoder processes in parallel.
    '';
    changelog = "https://github.com/master-of-zen/Av1an/releases/tag/${av1an-unwrapped.version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ getchoo ];
  };
}

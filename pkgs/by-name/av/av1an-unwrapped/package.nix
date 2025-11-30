{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ffmpeg,
  libaom,
  nasm,
  nix-update-script,
  pkg-config,
  rav1e,
  rustPlatform,
  vapoursynth,
}:

rustPlatform.buildRustPackage rec {
  pname = "av1an-unwrapped";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "rust-av";
    repo = "Av1an";
    tag = version;
    hash = "sha256-jlRB/9oropbh4mGg0kFDFWKFvSe13wCcrWr3O1TKTHo=";
  };

  cargoHash = "sha256-ya0mY8E6ww7jGNwnCdOZD4obNhZojXlx5SR7drVsiBA=";

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
        "'^(\\d*\\.\\d*\\.\\d*)$'"
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
    changelog = "https://github.com/rust-av/Av1an/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "av1an";
    # symbol index out of range file '/private/tmp/nix-build-av1an-unwrapped-0.4.4.drv-0/rustcz0anL2/librav1e-ca440893f9248a14.rlib' for architecture x86_64
    broken = stdenv.hostPlatform.system == "x86_64-darwin";
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ffmpeg_7,
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
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "master-of-zen";
    repo = "av1an";
    tag = version;
    hash = "sha256-YF+j349777pE+evvXWTo42DQn1CE0jlfKBEXUFTfcb8=";
  };

  cargoPatches = [
    # TODO: Remove in next version
    # Avoids https://github.com/shssoichiro/ffmpeg-the-third/issues/63
    # https://github.com/master-of-zen/Av1an/pull/912
    (fetchpatch {
      url = "https://github.com/master-of-zen/Av1an/commit/e6b29a5a624434eb0dc95b7e8aa31ccf624ccb9d.patch";
      hash = "sha256-nFE04hlTzApYafSzgl/XOUdchxEjKvxXy+SKr/d6+0Q=";
    })
  ];

  cargoHash = "sha256-PcxnWkruFH4d2FqS+y3PmyA70kSe9BKtmTdCnfKnfpU=";

  nativeBuildInputs = [
    nasm
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg_7
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
    homepage = "https://github.com/master-of-zen/Av1an";
    changelog = "https://github.com/master-of-zen/Av1an/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "av1an";
    # symbol index out of range file '/private/tmp/nix-build-av1an-unwrapped-0.4.4.drv-0/rustcz0anL2/librav1e-ca440893f9248a14.rlib' for architecture x86_64
    broken = stdenv.hostPlatform.system == "x86_64-darwin";
  };
}

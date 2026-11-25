{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  nasm,

  # for passthru.tests
  ffmpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Z23LtZNgyimaYGgXQVDrNVNPNSWgZ8fWEsBZuoCSgs=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    nasm
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DSVT_AV1_LTO=ON"
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "-";
    };
    tests = {
      ffmpeg = ffmpeg.override { withSvtav1 = true; };
    };
  };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/AOMediaCodec/SVT-AV1";
    description = "AV1-compliant encoder/decoder library core";

    longDescription = ''
      The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an
      AV1-compliant encoder/decoder library core. The SVT-AV1 encoder
      development is a work-in-progress targeting performance levels applicable
      to both VOD and Live encoding / transcoding video applications. The
      SVT-AV1 decoder implementation is targeting future codec research
      activities.
    '';

    changelog = "https://github.com/AOMediaCodec/SVT-AV1/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      aom
      bsd3
    ];
    mainProgram = "SvtAv1EncApp";
    platforms = lib.platforms.unix;
  };
})

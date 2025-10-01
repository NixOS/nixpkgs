{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch2,
  gitUpdater,
  cmake,
  nasm,
  cpuinfo,

  # for passthru.tests
  ffmpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1";
  version = "3.0.2";

  src = fetchFromGitLab {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WS9awjnJV0ok6ePlLcpHPAr2gsZjbZcdFSDEmyx7vwk=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://gitlab.com/AOMediaCodec/SVT-AV1/-/commit/ec699561b51f3204e2df6d4c2578eea1f7bd52be.patch?full_index=1";
      hash = "sha256-QVdvqWWT5tlNKBX9pQJwWgaOq+wNkYiBJTSeytRxrwo=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    nasm
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isx86_64 [
    cpuinfo
  ];

  cmakeFlags = [
    "-DSVT_AV1_LTO=ON"
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
    tests = {
      ffmpeg = ffmpeg.override { withSvtav1 = true; };
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.com/AOMediaCodec/SVT-AV1";
    description = "AV1-compliant encoder/decoder library core";

    longDescription = ''
      The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an
      AV1-compliant encoder/decoder library core. The SVT-AV1 encoder
      development is a work-in-progress targeting performance levels applicable
      to both VOD and Live encoding / transcoding video applications. The
      SVT-AV1 decoder implementation is targeting future codec research
      activities.
    '';

    changelog = "https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with licenses; [
      aom
      bsd3
    ];
    mainProgram = "SvtAv1EncApp";
    platforms = platforms.unix;
  };
})

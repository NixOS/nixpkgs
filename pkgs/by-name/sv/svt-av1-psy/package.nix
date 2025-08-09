{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nasm,
  cpuinfo,
  libdovi,
  hdr10plus,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1-psy";
  version = "3.0.2-unstable-2025-04-21";

  src = fetchFromGitHub {
    owner = "psy-ex";
    repo = "svt-av1-psy";
    rev = "3745419c40267d294202b52f48f069aff56cdb78";
    hash = "sha256-iAw2FiEsBGB4giWqzo1EJZok26WSlq7brq9kJubnkAQ=";
  };

  cmakeBuildType = "Release";

  cmakeFlags =
    lib.mapAttrsToList
      (
        n: v:
        lib.cmakeOptionType (builtins.typeOf v) n (
          if builtins.isBool v then lib.boolToString v else toString v
        )
      )
      {
        LIBDOVI_FOUND = true;
        LIBHDR10PLUS_RS_FOUND = true;
      };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    nasm
  ];

  buildInputs = [
    libdovi
    hdr10plus
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    cpuinfo
  ];

  passthru.updateScript = unstableGitUpdater {
    branch = "master";
    tagPrefix = "v";
  };

  meta = {
    homepage = "https://github.com/psy-ex/svt-av1-psy";
    description = "Scalable Video Technology AV1 Encoder and Decoder";

    longDescription = ''
      SVT-AV1-PSY is the Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)
      with perceptual enhancements for psychovisually optimal AV1 encoding.
      The goal is to create the best encoding implementation for perceptual quality with AV1.
    '';

    license = with lib.licenses; [
      aom
      bsd3
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ johnrtitor ];
    mainProgram = "SvtAv1EncApp";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  yasm,
  cpuinfo,
  libdovi,
  hdr10plus,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1-psyex";
  version = "3.0.2-B";

  src = fetchFromGitHub {
    owner = "BlueSwordM";
    repo = "svt-av1-psyex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-klfrbow8UtpIPwIgt8tK7FP7Jp6In9nxfOZrdi1PsHo=";
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
    yasm
  ];

  buildInputs = [
    libdovi
    hdr10plus
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    cpuinfo
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    homepage = "https://github.com/BlueSwordM/svt-av1-psyex";
    description = "Scalable Video Technology AV1 Encoder and Decoder";

    longDescription = ''
      SVT-AV1-PSYEX is the Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)
      with perceptual enhancements for psychovisually optimal AV1 encoding.
      The goal is to create the best encoding implementation for perceptual quality with AV1.
    '';

    license = with lib.licenses; [
      aom
      bsd3
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      johnrtitor
      ccicnce113424
    ];
    mainProgram = "SvtAv1EncApp";
  };
})

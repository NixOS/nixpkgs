{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  yasm,
  cpuinfo,
  libdovi,
  hdr10plus,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1-hdr";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "juliobbv-p";
    repo = "svt-av1-hdr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n66RPDTfBsPCR/4y8dpU3Au1WZHpkpln899e2+LKxto=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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
    pkg-config
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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/juliobbv-p/svt-av1-hdr";
    description = "Scalable Video Technology AV1 Encoder and Decoder";

    longDescription = ''
      SVT-AV1-HDR is the Scalable Video Technology for AV1 (SVT-AV1 Encoder)
      with perceptual enhancements for psychovisually optimal SDR and HDR AV1 encoding.
      The goal is to create the best encoding implementation for perceptual quality with AV1,
      with additional optimizations for HDR encoding and content with film grain.
    '';

    license = with lib.licenses; [
      aom
      bsd3
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      ccicnce113424
      claraphyll
    ];
    mainProgram = "SvtAv1EncApp";
  };
})

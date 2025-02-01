{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nasm,
  libdovi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1-psy";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "gianni-rosato";
    repo = "svt-av1-psy";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-qySrYZDwmoKf7oAQJlBSWInXeOceGSeL2Kc09SJ5Zs0=";
  };

  cmakeBuildType = "Release";

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    LIBDOVI_FOUND = lib.boolToString true;
    # enable when libhdr10plus is available
    # LIBHDR10PLUS_RS_FOUND = lib.boolToString true;
  };

  nativeBuildInputs = [
    cmake
    nasm
  ];

  buildInputs = [
    libdovi
  ];

  meta = {
    homepage = "https://github.com/gianni-rosato/svt-av1-psy";
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
  };
})

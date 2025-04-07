{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nasm,
  cpuinfo,
  libdovi,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1-psy";
  version = "2.3.0-B-unstable-2025-02-02";

  src = fetchFromGitHub {
    owner = "psy-ex";
    repo = "svt-av1-psy";
    rev = "ec65071b65ee70078229182ce6e1d0f6a4aa1a47";
    hash = "sha256-98u7J9tqrnc+MbryjWO2r9iuAy6QjJbbq0/o4xRLzhI=";
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
        USE_EXTERNAL_CPUINFO = true;
        LIBDOVI_FOUND = true;
        # enable when libhdr10plus is available
        # LIBHDR10PLUS_RS_FOUND = true;
      };

  nativeBuildInputs = [
    cmake
    nasm
  ];

  buildInputs = [
    cpuinfo
    libdovi
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
  };
})

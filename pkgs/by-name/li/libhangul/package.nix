{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhangul";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/libhangul/libhangul/releases/download/libhangul-${finalAttrs.version}/libhangul-${finalAttrs.version}.tar.gz";
    hash = "sha256-6gTmoM9IQKKjtWQcF2EGjHhpEDbbg50IOPTnplU6USA=";
  };

  configureFlags = [
    # detection doesn't work for cross builds
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = {
    description = "Core algorithm library for Korean input routines";
    mainProgram = "hangul";
    homepage = "https://github.com/libhangul/libhangul";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      ianwookim
      honnip
    ];
    platforms = lib.platforms.linux;
  };
})

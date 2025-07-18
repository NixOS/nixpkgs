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

  meta = with lib; {
    description = "Core algorithm library for Korean input routines";
    mainProgram = "hangul";
    homepage = "https://github.com/libhangul/libhangul";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      ianwookim
      honnip
    ];
    platforms = platforms.linux;
  };
})

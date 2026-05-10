{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhangul";
  version = "0.1.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libhangul/libhangul-${finalAttrs.version}.tar.gz";
    sha256 = "0ni9b0v70wkm0116na7ghv03pgxsfpfszhgyj3hld3bxamfal1ar";
  };

  configureFlags = [
    # detection doesn't work for cross builds
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = {
    description = "Core algorithm library for Korean input routines";
    mainProgram = "hangul";
    homepage = "https://github.com/choehwanjin/libhangul";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.ianwookim ];
    platforms = lib.platforms.linux;
  };
})

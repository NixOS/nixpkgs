{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.99";
  pname = "barcode";
  src = fetchurl {
    url = "mirror://gnu/barcode/barcode-${finalAttrs.version}.tar.xz";
    hash = "sha256-6H7PZCFXPhfONYeduDKGF3lSWGUIMa/9Al+6QvFVzcY=";
  };
  patches = [
    # Pull upstream patch for -fno-common toolchains.
    (fetchpatch {
      name = "fno-common.patch";
      url = "http://git.savannah.gnu.org/cgit/barcode.git/patch/?id=4654f68706a459c9602d9932b56a56e8930f7d53";
      hash = "sha256-7Lm8993bIx8e8ZO51YnjAKP0UQVsI1JPrh5AytmnbJY=";
    })
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "ac_cv_func_calloc_0_nonnull=yes";

  hardeningDisable = [ "format" ];

  meta = {
    description = "GNU barcode generator";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    downloadPage = "https://ftp.gnu.org/gnu/barcode/";
    homepage = "https://www.gnu.org/software/barcode/";
    license = lib.licenses.gpl3;
  };
})

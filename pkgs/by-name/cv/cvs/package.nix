{
  lib,
  fetchpatch,
  fetchurl,
  nano,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cvs";
  version = "1.12.13";

  src = fetchurl {
    url = "mirror://savannah/cvs/source/feature/${finalAttrs.version}/cvs-${finalAttrs.version}.tar.bz2";
    hash = "sha256-eIU2E7mmhzow4cwkF/c4wzDnX4h6/a97PQgAyxnKUV4=";
  };

  patches = [
    ./patches/0000-readdir-errno.patch
    ./patches/0001-getcwd-chroot.patch
    ./patches/0002-CVE-2012-0804.patch
    ./patches/0003-CVE-2017-12836.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/formula-patches/24118ec737c7/cvs/vasnprintf-high-sierra-fix.diff";
      hash = "sha256-r/pIUzL2a7GCljaA+QVSk3vxRVuFU4j3wG72o6JShuI=";
    })
  ];

  hardeningDisable = [
    "fortify"
    "format"
  ];

  configureFlags = [
    "--with-editor=${nano}/bin/nano"

    # Required for cross-compilation.
    "cvs_cv_func_printf_ptr=yes"
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  env = lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.cc.isClang) {
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  };

  doCheck = false; # fails 1 of 1 tests

  meta = {
    homepage = "http://cvs.nongnu.org";
    description = "Concurrent Versions System";
    license = with lib.licenses; [
      gpl1Plus # program
      gpl2Plus # library
    ];
    mainProgram = "cvs";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})

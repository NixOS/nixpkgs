{
  lib,
  fetchpatch2,
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
    (fetchpatch2 {
      name = "0000-readdir-errno.patch";
      url = "https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=commitdiff_plain;h=0b78641d85af3b72e3b9d94cb7b94e45f3c08ee5";
      includes = [
        "lib/getcwd.c"
      ];
      hash = "sha256-pfvFp335MNeRd8r1ZGHTN7MQfOKLB390WE4MW1cH3Y0=";
    })
    (fetchpatch2 {
      name = "0001-getcwd-chroot.patch";
      url = "https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=commitdiff_plain;h=79c0a43808d9ca85acd04600149fc1a9b75bd1b9";
      includes = [
        "lib/getcwd.c"
      ];
      hash = "sha256-u9sziWbZvjUH6flxOexLcn1ZEWTfn/ce6Es9/PxTKSM=";
    })
    ./patches/0002-CVE-2012-0804.patch
    ./patches/0003-CVE-2017-12836.patch
    (fetchpatch2 {
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

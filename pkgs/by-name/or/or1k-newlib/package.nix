{
  lib,
  stdenv,
  fetchFromGitHub,
  stdenvNoLibc,
  buildPackages,
  texinfo,
}:

stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "or1k-newlib";
  version = "4.5.0-20250328";

  src = fetchFromGitHub {
    owner = "openrisc";
    repo = "newlib";
    tag = "or1k-${finalAttrs.version}";
    hash = "sha256-yQAd+Dbz4F6fNTEq4URUVGLWv2oS54e7YqccUc2sxS0=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    texinfo # for makeinfo, needed by libgloss/doc
  ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [
    "build"
    "target"
  ];
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"

    "--disable-newlib-supplied-syscalls"
    "--disable-nls"
    "--enable-newlib-io-long-long"
    "--enable-newlib-register-fini"
    "--enable-newlib-retargetable-locking"
  ];

  dontDisableStatic = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };

  meta = {
    description = "Newlib C library with OpenRISC 1000 (or1k) support";
    homepage = "https://github.com/openrisc/newlib";
    # same licensing situation as the plain newlib package:
    # COPYING, COPYING.LIB, COPYING.LIBGLOSS, COPYING.NEWLIB, COPYING3
    license = lib.licenses.gpl2Plus;
    platforms = [ "or1k-none" ];
    maintainers = with lib.maintainers; [ lrfe ];
  };
})

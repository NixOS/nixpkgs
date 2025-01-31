{ lib, stdenv, fetchurl, fetchpatch, nano }:

stdenv.mkDerivation rec {
  pname = "cvs";
  version = "1.12.13";

  src = fetchurl {
    url = "mirror://savannah/cvs/source/feature/${version}/cvs-${version}.tar.bz2";
    sha256 = "0pjir8cwn0087mxszzbsi1gyfc6373vif96cw4q3m1x6p49kd1bq";
  };

  patches = [
    ./getcwd-chroot.patch
    ./CVE-2012-0804.patch
    ./CVE-2017-12836.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/formula-patches/24118ec737c7/cvs/vasnprintf-high-sierra-fix.diff";
      sha256 = "1ql6aaia7xkfq3vqhlw5bd2z2ywka82zk01njs1b2szn699liymg";
    })
  ];

  hardeningDisable = [ "fortify" "format" ];

  preConfigure = ''
    # Apply the Debian patches.
    for p in "debian/patches/"*; do
      echo "applying \`$p' ..."
      patch --verbose -p1 < "$p"
    done
  '';

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

  meta = with lib; {
    homepage = "http://cvs.nongnu.org";
    description = "Concurrent Versions System - a source control system";
    license = licenses.gpl2Plus; # library is GPLv2, main is GPLv1
    platforms = platforms.all;
  };
}

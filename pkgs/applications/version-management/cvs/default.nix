{ stdenv, fetchurl, fetchpatch, nano }:

stdenv.mkDerivation {
  name = "cvs-1.12.13";

  src = fetchurl {
    url = mirror://savannah/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2;
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

  buildInputs = [ nano ];

  doCheck = false; # fails 1 of 1 tests

  meta = with stdenv.lib; {
    homepage = http://cvs.nongnu.org;
    description = "Concurrent Versions System - a source control system";
    license = licenses.gpl2; # library is GPLv2, main is GPLv1
    platforms = platforms.all;
  };
}

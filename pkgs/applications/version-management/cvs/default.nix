{ stdenv, fetchurl, nano }:

stdenv.mkDerivation {
  name = "cvs-1.12.13";

  src = fetchurl {
    url = mirror://savannah/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2;
    sha256 = "0pjir8cwn0087mxszzbsi1gyfc6373vif96cw4q3m1x6p49kd1bq";
  };

  patches = [ ./getcwd-chroot.patch ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    # Apply the Debian patches.
    for p in "debian/patches/"*; do
      echo "applying \`$p' ..."
      patch --verbose -p1 < "$p"
    done
  '';

  buildInputs = [ nano ];

  meta = {
    homepage = "http://cvs.nongnu.org";
    description = "Concurrent Versions System - a source control system";
    platforms = stdenv.lib.platforms.all;
  };
}

{ stdenv, fetchurl, nano }:

stdenv.mkDerivation {
  name = "cvs-1.12.13";

  src = fetchurl {
    url = http://ftp.gnu.org/non-gnu/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2;
    sha256 = "0pjir8cwn0087mxszzbsi1gyfc6373vif96cw4q3m1x6p49kd1bq";
  };

  patches = [ ./getcwd-chroot.patch ];

  preConfigure = ''
    # Fix location of info and man directories.
    configureFlags="--infodir=$out/share/info --mandir=$out/share/man"

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
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}

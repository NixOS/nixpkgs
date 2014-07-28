{ stdenv, fetchurl, db, gtk, bzip2 }:

stdenv.mkDerivation {
  name = "jigdo-0.7.3";

  # Debian sources
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/j/jigdo/jigdo_0.7.3.orig.tar.gz;
    sha256 = "1qvqzgzb0dzq82fa1ffs6hyij655rajnfwkljk1y0mnkygnha1xv";
  };

  patches = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/j/jigdo/jigdo_0.7.3-2.diff.gz;
    sha256 = "0jnlzm9m2hjlnw0zs2fv456ml5r2jj2q1lncqbrgg52lq18f6fa3";
  };

  buildInputs = [ db gtk bzip2 ];

  configureFlags = "--without-libdb";

  meta = {
    description = "Download utility that can fetch files from several sources simultaneously";
    homepage = http://atterer.net/jigdo/;
    license = stdenv.lib.licenses.gpl2;
  };
}

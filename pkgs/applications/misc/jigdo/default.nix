args: with args;

stdenv.mkDerivation {
  name = "jigdo-0.7.3";

  # Debian sources 
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/j/jigdo/jigdo_0.7.3.orig.tar.gz;
    sha256 = "1qvqzgzb0dzq82fa1ffs6hyij655rajnfwkljk1y0mnkygnha1xv";
  };

  buildInputs = [db45 gtk bzip2];

  configureFlags = "--without-libdb";

  meta = { 
    description = "tool designed to ease the distribution of very large files over the internet";
    homepage = http://atterer.net/jigdo/;
    license = "GPLv2";
  };

  patches = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/j/jigdo/jigdo_0.7.3-2.diff.gz;
    sha256 = "0jnlzm9m2hjlnw0zs2fv456ml5r2jj2q1lncqbrgg52lq18f6fa3";
  };
}

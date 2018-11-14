{ stdenv, fetchurl, db, gtk2, bzip2 }:

stdenv.mkDerivation {
  name = "jigdo-0.7.3";

  # Debian sources
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/j/jigdo/jigdo_0.7.3.orig.tar.gz;
    sha256 = "1qvqzgzb0dzq82fa1ffs6hyij655rajnfwkljk1y0mnkygnha1xv";
  };

  patches = [
    (fetchurl {
      url = http://ftp.de.debian.org/debian/pool/main/j/jigdo/jigdo_0.7.3-4.diff.gz;
      sha256 = "03zsh57fijciiv23lf55k6fbfhhzm866xjhx83x54v5s1g2h6m8y";
    })
    ./sizewidth.patch
  ];

  buildInputs = [ db gtk2 bzip2 ];

  configureFlags = [ "--without-libdb" ];

  meta = {
    description = "Download utility that can fetch files from several sources simultaneously";
    homepage = http://atterer.net/jigdo/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}

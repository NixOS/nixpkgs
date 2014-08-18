{stdenv, fetchurl, openssl, curl, ncurses, libjpeg
, withGpg ? true, gpgme ? null}:

stdenv.mkDerivation rec {
  version = "4.22.10";
  debPatch = "2";
  name = "centerim-${version}";

  src = fetchurl {
    url = "http://centerim.org/download/releases/${name}.tar.gz";
    sha256 = "0viz86jflp684vfginhl6aaw4gh2qvalc25anlwljjl3kkmibklk";
  };
  patches = fetchurl {
    url = "mirror://debian/pool/main/c/centerim/centerim_${version}-${debPatch}.diff.gz";
    sha256 = "18iz3hkvr31jsyznryvyldxm9ckyrpy9sczxikrnw2i2r1xyfj8m";
  };

  buildInputs = [ openssl curl ncurses libjpeg ]
    ++ stdenv.lib.optional withGpg gpgme;

  configureFlags = [ "--with-openssl=${openssl}" ];

  meta = {
    homepage = http://www.centerim.org/;
    description = "Fork of CenterICQ, a curses instant messaging program";
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}

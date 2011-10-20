{stdenv, fetchurl, readline, openssh}:

stdenv.mkDerivation {
  name = "yafc-1.1.1";
  src = fetchurl {
    url = mirror://sourceforge/yafc/yafc-1.1.1.tar.bz2;
    sha256 = "ab72b2ed89fb75dbe8ebd119458cf513392225f367cccfad881e9780aefcd7e6";
  };

  buildInputs = [readline openssh];

  patchPhase = "
    sed -e 's@/usr/bin/ssh@${openssh}/bin/ssh@' -i src/main.c
  ";

  meta = {
    description = "ftp/sftp client with readline, autocompletion and bookmarks";
    homepage = http://yafc.sourceforge.net;
    license = "GPLv2+";
  };
}

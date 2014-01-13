{ fetchurl, stdenv, confuse, yajl, alsaLib, wirelesstools
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.8";

  src = fetchurl {
    url = "http://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "1zh7z2qbw0jsrqdkc1irviq2n20mc5hq4h1mckyfcm238pfwa1mb";
  };

  buildInputs = [ confuse yajl alsaLib wirelesstools ];

  makeFlags = "all";
  installFlags = "PREFIX=\${out}";

  meta = {
    description = "i3 is a tiling window manager";
    homepage = http://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };

}

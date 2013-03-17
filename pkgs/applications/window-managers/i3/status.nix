{ fetchurl, stdenv, confuse, yajl, alsaLib, wirelesstools
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.7";

  src = fetchurl {
    url = "http://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "0cm6fhsc7hzsqni8pwhjl2l0rfd458paabn54cgzqnmwwdflwgq7";
  };

  buildInputs = [ confuse yajl alsaLib wirelesstools ];

  makeFlags = "all";
  installFlags = "PREFIX=\${out}";

  meta = {
    description = "i3 is a tiling window manager";
    homepage = http://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
  };

}

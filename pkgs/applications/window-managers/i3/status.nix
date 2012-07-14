{ fetchurl, stdenv, confuse, yajl, alsaLib, wirelesstools
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.5.1";

  src = fetchurl {
    url = "http://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "7734efdf79a77617023f1e6d80080251eab3a05defb67313283568511d3e58f2";
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

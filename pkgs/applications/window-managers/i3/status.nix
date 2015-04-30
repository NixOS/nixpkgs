{ fetchurl, stdenv, confuse, yajl, alsaLib, wirelesstools
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.9";

  src = fetchurl {
    url = "http://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "1qwxbrga2fi5wf742hh9ajwa8b2kpzkjjnhjlz4wlpv21i80kss2";
  };

  buildInputs = [ confuse yajl alsaLib wirelesstools ];

  makeFlags = "all";
  installFlags = "PREFIX=\${out}";

  meta = {
    description = "A tiling window manager";
    homepage = http://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };

}

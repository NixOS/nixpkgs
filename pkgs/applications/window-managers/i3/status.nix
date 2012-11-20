{ fetchurl, stdenv, confuse, yajl, alsaLib, wirelesstools
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.6";

  src = fetchurl {
    url = "http://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "e7e710cc271887bcd22757269e1b00a5618fb53abdb3455140116b3d38797bce";
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

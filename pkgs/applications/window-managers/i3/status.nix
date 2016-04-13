{ fetchurl, stdenv, confuse, yajl, alsaLib, libpulseaudio, libnl, pkgconfig
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.10";

  src = fetchurl {
    url = "http://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "1497dsvb32z9xljmxz95dnyvsbayn188ilm3l4ys8m5h25vd1xfs";
  };

  buildInputs = [ confuse yajl alsaLib libpulseaudio libnl pkgconfig ];

  makeFlags = [ "all" "PREFIX=$(out)" ];

  meta = {
    description = "A tiling window manager";
    homepage = http://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };

}

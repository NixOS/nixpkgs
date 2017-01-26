{ fetchurl, stdenv, confuse, yajl, alsaLib, libpulseaudio, libnl, pkgconfig
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.11";

  src = fetchurl {
    url = "http://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "0pwcy599fw8by1a1sf91crkqba7679qhvhbacpmhis8c1xrpxnwq";
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

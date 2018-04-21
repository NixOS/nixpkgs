{ fetchurl, stdenv, confuse, yajl, alsaLib, libpulseaudio, libnl, pkgconfig
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.11";

  src = fetchurl {
    url = "https://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "0pwcy599fw8by1a1sf91crkqba7679qhvhbacpmhis8c1xrpxnwq";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ confuse yajl alsaLib libpulseaudio libnl ];

  makeFlags = [ "all" "PREFIX=$(out)" ];

  meta = {
    description = "A tiling window manager";
    homepage = http://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };

}

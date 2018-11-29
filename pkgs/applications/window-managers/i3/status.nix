{ fetchurl, stdenv, libconfuse, yajl, alsaLib, libpulseaudio, libnl, pkgconfig
  }:

stdenv.mkDerivation rec {
  name = "i3status-2.12";

  src = fetchurl {
    url = "https://i3wm.org/i3status/${name}.tar.bz2";
    sha256 = "06krpbijv4yi33nypg6qcn4hilcrdyarsdpd9fmr2cq46qaqiikg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libconfuse yajl alsaLib libpulseaudio libnl ];

  makeFlags = [ "all" "PREFIX=$(out)" ];

  meta = {
    description = "A tiling window manager";
    homepage = https://i3wm.org;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };

}

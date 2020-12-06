{ stdenv, fetchurl, alsaLib, gtkmm2, libjack2, pkgconfig }:

stdenv.mkDerivation  rec {
  pname = "seq24";
  version = "0.9.3";

  src = fetchurl {
    url = "https://launchpad.net/seq24/trunk/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1qpyb7355s21sgy6gibkybxpzx4ikha57a8w644lca6qy9mhcwi3";
  };

  patches = [ ./mutex_no_nameclash.patch ];

  buildInputs = [ alsaLib gtkmm2 libjack2 ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Minimal loop based midi sequencer";
    homepage = "http://www.filter24.org/seq24";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu ];
  };
}

{ stdenv, fetchurl, alsaLib, gtkmm, libjack2, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "seq24-${version}";
  version = "0.9.3";

  src = fetchurl {
    url = "http://launchpad.net/seq24/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1qpyb7355s21sgy6gibkybxpzx4ikha57a8w644lca6qy9mhcwi3";
  };

  buildInputs = [ alsaLib gtkmm libjack2 ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "minimal loop based midi sequencer";
    homepage = "http://www.filter24.org/seq24";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu nckx ];
  };
}

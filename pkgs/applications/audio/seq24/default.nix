{ stdenv, fetchurl, alsaLib, gtkmm, jack2, pkgconfig }:

stdenv.mkDerivation  rec {
  name = "seq24-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "http://launchpad.net/seq24/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "07n80zj95i80vjmsflnlbqx5vv90qmp5f6a0zap8d30849l4y258";
  };

  buildInputs = [ alsaLib gtkmm jack2 pkgconfig ];

  meta = with stdenv.lib; {
    description = "minimal loop based midi sequencer";
    homepage = "http://www.filter24.org/seq24";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}

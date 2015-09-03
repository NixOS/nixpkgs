{ stdenv, fetchurl, pkgconfig, mpd_clientlib, dbus_glib, audacious, gtk, gsl
, libaudclient }:

stdenv.mkDerivation {
  name = "gjay-0.3.2";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/gjay/gjay-0.3.2.tar.gz";
    sha256 = "1a1vv4r0vnxjdyl0jyv7gga3zfd5azxlwjm1l6hjrf71lb228zn8";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ mpd_clientlib dbus_glib audacious gtk gsl libaudclient ];

  meta = with stdenv.lib; {
    description = "Generates playlists such that each song sounds good following the previous song";
    homepage = http://gjay.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}

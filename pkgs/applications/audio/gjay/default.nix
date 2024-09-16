{ lib
, stdenv
, fetchurl
, pkg-config
, dbus-glib
, audacious
, gtk2
, gsl
, libaudclient
, libmpdclient
}:

stdenv.mkDerivation rec {
  pname = "gjay";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/gjay/${pname}-${version}.tar.gz";
    sha256 = "1a1vv4r0vnxjdyl0jyv7gga3zfd5azxlwjm1l6hjrf71lb228zn8";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libmpdclient
    dbus-glib
    audacious
    gtk2
    gsl
    libaudclient
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Generates playlists such that each song sounds good following the previous song";
    homepage = "https://gjay.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    mainProgram = "gjay";
  };
}

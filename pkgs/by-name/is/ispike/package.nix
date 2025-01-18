{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "ispike";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/ispike/${pname}-${version}.tar.gz";
    sha256 = "0khrxp43bi5kisr8j4lp9fl4r5marzf7b4inys62ac108sfb28lp";
  };

  postPatch = ''
    sed -i "1i #include <map>" include/iSpike/YarpConnection.hpp
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  meta = with lib; {
    description = "Spiking neural interface between iCub and a spiking neural simulator";
    homepage = "https://sourceforge.net/projects/ispike/";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.nico202 ];
  };
}

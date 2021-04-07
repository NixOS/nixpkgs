{ lib, stdenv, fetchurl, libosip }:

stdenv.mkDerivation rec {
  name = "siproxd-0.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/siproxd/${name}.tar.gz";
    sha256 = "1l6cyxxhra825jiiw9npa7jrbfgbyfpk4966cqkrw66cn28y8v2j";
  };

  patches = [ ./cheaders.patch ];

  buildInputs = [ libosip ];

  meta = {
    homepage = "http://siproxd.sourceforge.net/";
    description = "A masquerading SIP Proxy Server";
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
    license = lib.licenses.gpl2Plus;
  };
}

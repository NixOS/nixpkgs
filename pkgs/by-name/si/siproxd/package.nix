{
  lib,
  stdenv,
  fetchurl,
  libosip,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "siproxd";
  version = "0.8.3";

  src = fetchurl {
    url = "mirror://sourceforge/siproxd/siproxd-${version}.tar.gz";
    sha256 = "0dkpl3myxz3gvj2n2qpqrd19dip9il0vf7qybdvn5wgznrmplvcs";
  };

  patches = [ ./cheaders.patch ];

  buildInputs = [
    libosip
    sqlite
  ];

  meta = {
    homepage = "http://siproxd.sourceforge.net/";
    description = "Masquerading SIP Proxy Server";
    mainProgram = "siproxd";
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    license = lib.licenses.gpl2Plus;
  };
}

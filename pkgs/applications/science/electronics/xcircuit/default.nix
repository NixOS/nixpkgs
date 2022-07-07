{ lib, stdenv, fetchurl, autoreconfHook, automake, pkg-config
, cairo, ghostscript, ngspice, tcl, tk, xorg, zlib }:

stdenv.mkDerivation rec {
  version = "3.10.12";
  pname = "xcircuit";

  src = fetchurl {
    url = "http://opencircuitdesign.com/xcircuit/archive/xcircuit-${version}.tgz";
    sha256 = "1h1ywc3mr7plvwnhdii2zgnnv5ih2nhyl4qbdjpi83dq0aq1s2mn";
  };

  nativeBuildInputs = [ autoreconfHook automake pkg-config ];
  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--with-ngspice=${lib.getBin ngspice}/bin/ngspice"
  ];

  buildInputs = with xorg; [ cairo ghostscript libSM libXt libICE libX11 libXpm tcl tk zlib ];

  meta = with lib; {
    description = "Generic drawing program tailored to circuit diagrams";
    homepage = "http://opencircuitdesign.com/xcircuit";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ spacefrogg thoughtpolice ];
  };
}

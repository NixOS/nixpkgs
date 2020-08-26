{ stdenv, fetchurl, autoreconfHook, automake, pkgconfig
, cairo, ghostscript, ngspice, tcl, tk, xorg, zlib }:

let
  version = "3.10.12";
  name = "xcircuit-${version}";
  inherit (stdenv.lib) getBin;

in stdenv.mkDerivation {
  inherit name version;

  src = fetchurl {
    url = "http://opencircuitdesign.com/xcircuit/archive/${name}.tgz";
    sha256 = "1h1ywc3mr7plvwnhdii2zgnnv5ih2nhyl4qbdjpi83dq0aq1s2mn";
  };

  nativeBuildInputs = [ autoreconfHook automake pkgconfig ];
  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--with-ngspice=${getBin ngspice}/bin/ngspice"
  ];

  buildInputs = with xorg; [ cairo ghostscript libSM libXt libICE libX11 libXpm tcl tk zlib ];

  meta = with stdenv.lib; {
    description = "Generic drawing program tailored to circuit diagrams";
    homepage = "http://opencircuitdesign.com/xcircuit";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ spacefrogg thoughtpolice ];
  };
}

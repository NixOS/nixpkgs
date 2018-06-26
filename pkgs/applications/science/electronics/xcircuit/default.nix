{ stdenv, fetchurl, autoreconfHook, automake, pkgconfig
, cairo, ghostscript, ngspice, tcl, tk, xorg, zlib }:

let
  version = "3.10.10";
  name = "xcircuit-${version}";
  inherit (stdenv.lib) getBin;

in stdenv.mkDerivation {
  inherit name version;

  src = fetchurl {
    url = "http://opencircuitdesign.com/xcircuit/archive/${name}.tgz";
    sha256 = "0fd5ycrlnk7jq34hlanhjs1pj2skd4qmm0shidigcrw0q5gc39pa";
  };

  nativeBuildInputs = [ autoreconfHook automake pkgconfig ];
  hardeningDisable = [ "format" ];

  configureFlags = "--with-tcl=${tcl}/lib --with-tk=${tk}/lib --with-ngspice=${getBin ngspice}/bin/ngspice";

  buildInputs = with xorg; [ cairo ghostscript libSM libXt libICE libX11 libXpm tcl tk zlib ];

  meta = with stdenv.lib; {
    description = "Generic drawing program tailored to circuit diagrams";
    homepage = http://opencircuitdesign.com/xcircuit;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.spacefrogg ];
  };
}

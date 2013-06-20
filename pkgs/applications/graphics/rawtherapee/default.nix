{ stdenv, fetchurl, pkgconfig, gtk, cmake, pixman, libpthreadstubs, gtkmm, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra, fftw, expat
, mercurial  # Not really needed for anything, but it fails if it does not find 'hg'
}:

stdenv.mkDerivation rec {
  name = "rawtherapee-4.0.10";
  
  src = fetchurl {
    url = http://rawtherapee.googlecode.com/files/rawtherapee-4.0.10.tar.xz;
    sha256 = "1ibsdm2kqpw796rcdihnnp67vx0wm1d1bnlzq269r9p01w5s102g";
  };
  
  buildInputs = [ pkgconfig gtk cmake pixman libpthreadstubs gtkmm libXau libXdmcp
    lcms2 libiptcdata mercurial libcanberra fftw expat ];

  # Disable the use of the RAWZOR propietary libraries
  cmakeFlags = [ "-DWITH_RAWZOR=OFF" ];

  enableParallelBuilding = true;

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = http://www.rawtherapee.com/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric jcumming];
    platforms = with stdenv.lib.platforms; linux;
  };
}

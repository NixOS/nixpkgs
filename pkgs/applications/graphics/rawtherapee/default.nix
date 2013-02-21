{ stdenv, fetchurl, pkgconfig, gtk, cmake, pixman, libpthreadstubs, gtkmm, libXau
, libXdmcp, lcms2, libiptcdata, expat
, mercurial  # Not really needed for anything, but it fails if it does not find 'hg'
}:

stdenv.mkDerivation rec {
  name = "rawtherapee-4.0.9";
  
  src = fetchurl {
    url = http://rawtherapee.googlecode.com/files/rawtherapee-4.0.9.tar.xz;
    sha256 = "1ll7n7gzxs00jpw3gp9xfr90lbwqafkgqpps3j5ig6mf79frpm2a";
  };
  
  buildInputs = [ pkgconfig gtk cmake pixman libpthreadstubs gtkmm libXau libXdmcp
    lcms2 libiptcdata expat mercurial ];

  # Disable the use of the RAWZOR propietary libraries
  cmakeFlags = [ "-DWITH_RAWZOR=OFF" ];

  enableParallelBuilding = true;

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = http://www.rawtherapee.com/;
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

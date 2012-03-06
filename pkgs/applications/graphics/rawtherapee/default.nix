{ stdenv, fetchsvn, pkgconfig, gtk, cmake, pixman, libpthreadstubs, gtkmm, libXau,
libXdmcp, lcms, libiptcdata
}:

stdenv.mkDerivation rec {
  name = "rawtherapee-svn-25";
  
  src = fetchsvn {
    url = "http://rawtherapee.googlecode.com/svn/trunk";
    rev = 25;
    sha256 = "09jg47rs09lly70x1zlrb3qcwi2rry1m7gjzs39iqzp53hi9j9mh";
  };
  
  buildInputs = [ pkgconfig gtk cmake pixman libpthreadstubs gtkmm libXau libXdmcp
    lcms libiptcdata ];

  # Rawtherapee died if the default setting for the icc directory pointed to a
  # non existant place
  patchPhase = ''
    sed -i s,/usr/share/color/icc,/tmp/, rtgui/options.cc
  '';

  # Disable the use of the RAWZOR propietary libraries
  cmakeFlags = [ "-DWITH_RAWZOR=OFF" ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp rtgui/rt $out/bin
    # Weird kind of path reference
    cp -r ../release/* $out/bin
    cp rtengine/*.so $out/lib
  '';

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = http://www.rawtherapee.com/;
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

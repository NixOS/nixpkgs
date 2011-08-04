{ stdenv, fetchurl, pkgconfig, gtk, poppler }:

stdenv.mkDerivation rec {
  name = "zathura-0.0.8.4";
  
  src = fetchurl {
    url = "http://pwmt.org/download/${name}.tar.gz";
    sha256 = "03iq6n7bpgrkq3l8b2ab3flcfxrqpxc1f3ycn31xr2b6bjwi72qn";
  };
  
  buildInputs = [ pkgconfig gtk poppler ];

  makeFlags = "PREFIX=$(out)";
  
  meta = {
    homepage = https://pwmt.org/zathura/;
    description = "A highly customizable and functional PDF viewer";
    longDescription = ''
      Zathura is a highly customizable and functional PDF viewer based on the
      poppler rendering library and the gtk+ toolkit. The idea behind zathura
      is an application that provides a minimalistic and space saving interface
      as well as an easy usage that mainly focuses on keyboard interaction.
    '';
    license = "free";
    platforms = stdenv.lib.platforms.linux;
  };
}

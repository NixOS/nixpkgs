{ stdenv, fetchurl, perl, perlXMLParser, pkgconfig, gtk
, scrollkeeper, libglade, libXmu, libX11, libXext, gettext
, lame, libXfixes, libXdamage }:

stdenv.mkDerivation {
  name = "xvidcap-1.1.7";
  
  src = fetchurl {
    url = mirror://sourceforge/xvidcap/xvidcap-1.1.7.tar.gz;
    sha256 = "0p8rhpyhxgy37crf1xk1046z4p663jg7ww776jw92pld3s024ihm";
  };

  patches = [ ./xlib.patch ];
  buildInputs = [
    perl perlXMLParser pkgconfig gtk scrollkeeper
    libglade libXmu gettext lame libXdamage libXfixes libXext libX11
  ];

  # !!! don't know why this is necessary
  NIX_LDFLAGS = "-lXext -lX11 -lz -lgcc_s";

  meta = with stdenv.lib; { 
    description = "Screencast video catpuring tool";
    homepage = http://xvidcap.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
  };
}

{ fetchurl, stdenv, pkgconfig, exiv2, libxml2, gtk
, libxslt, docbook_xsl, docbook_xml_dtd_42 }:

stdenv.mkDerivation rec {
  name = "gpscorrelate-1.6.0";

  src = fetchurl {
    url = "http://freefoote.dview.net/linux/${name}.tar.gz";
    sha256 = "1j0b244xkvvf0i4iivp4dw9k4xgyasx4sapd91mnwki35fy49sp0";
  };

  buildInputs = [
    pkgconfig exiv2 libxml2 gtk
    libxslt docbook_xsl docbook_xml_dtd_42
  ];

  patchPhase = ''
    sed -i "Makefile" \
        -es",^[[:blank:]]*prefix[[:blank:]]*=.*$,prefix = $out,g"
  '';

  meta = {
    description = "A GPS photo correlation tool, to add EXIF geotags";

    longDescription = ''
      Digital cameras are cool.  So is GPS.  And, EXIF tags are really
      cool too.

      What happens when you merge the three?  You end up with a set of
      photos taken with a digital camera that are "stamped" with the
      location at which they were taken.

      The EXIF standard defines a number of tags that are for use with GPS.

      A variety of programs exist around the place to match GPS data
      with digital camera photos, but most of them are Windows or
      MacOS only.  Which doesn't really suit me that much. Also, each
      one takes the GPS data in a different format.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = http://freefoote.dview.net/linux_gpscorr.html;
    platforms = stdenv.lib.platforms.linux;
  };
}

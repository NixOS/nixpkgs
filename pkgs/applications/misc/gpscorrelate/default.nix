{ fetchFromGitHub, stdenv, pkgconfig, exiv2, libxml2, gtk2
, libxslt, docbook_xsl, docbook_xml_dtd_42 }:

stdenv.mkDerivation rec {
  name = "gpscorrelate-${version}";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "freefoote";
    repo = "gpscorrelate";
    rev = version;
    sha256 = "1z0fc75rx7dl6nnydksa578qv116j2c2xs1czfiijzxjghx8njdj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    exiv2 libxml2 gtk2
    libxslt docbook_xsl 
    docbook_xml_dtd_42
  ];

  patchPhase = ''
    sed -i "Makefile" \
        -es",^[[:blank:]]*prefix[[:blank:]]*=.*$,prefix = $out,g"
  '';

  meta = with stdenv.lib; {
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

    license = licenses.gpl2Plus;
    homepage = https://github.com/freefoote/gpscorrelate;
    platforms = platforms.linux;
  };
}

{ fetchFromGitHub, stdenv, fetchpatch, pkgconfig, exiv2, libxml2, gtk3
, libxslt, docbook_xsl, docbook_xml_dtd_42, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "gpscorrelate";
  version = "unstable-2019-06-05";

  src = fetchFromGitHub {
    owner = "dfandrich";
    repo = pname;
    rev = "80b14fe7c10c1cc8f62c13f517c062577ce88c85";
    sha256 = "1gaan0nd7ai0bwilfnkza7lg5mz87804mvlygj0gjc672izr37r6";
  };

  nativeBuildInputs = [
    desktop-file-utils
    docbook_xml_dtd_42
    docbook_xsl
    libxslt
    pkgconfig
  ];

  buildInputs = [
    exiv2
    gtk3
    libxml2
  ];

  makeFlags = [
    "prefix=${placeholder ''out''}"
    "GTK=3"
    "CC=cc"
    "CXX=c++"
  ];

  doCheck = true;

  installTargets = [ "install" "install-desktop-file" ];

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
    homepage = "https://github.com/dfandrich/gpscorrelate";
    platforms = platforms.linux;
  };
}

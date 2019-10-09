{ fetchFromGitHub, stdenv, fetchpatch, pkgconfig, exiv2, libxml2, gtk3
, libxslt, docbook_xsl, docbook_xml_dtd_42, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "gpscorrelate";
  version = "unstable-2019-09-03";

  src = fetchFromGitHub {
    owner = "dfandrich";
    repo = pname;
    rev = "e1dd44a34f67b1ab7201440e60a840258ee448d2";
    sha256 = "0gjwwdqh9dprzylmmnk3gm41khka9arkij3i9amd8y7d49pm9rlv";
  };

  patches = [ ./fix-localedir.diff ];

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
    "prefix=${placeholder "out"}"
    "GTK=3"
    "CC=cc"
    "CXX=c++"
    "CFLAGS=-DENABLE_NLS"
  ];

  doCheck = true;

  installTargets = [ "install" "install-po" "install-desktop-file" ];

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
    maintainers = with maintainers; [ sikmir ];
  };
}

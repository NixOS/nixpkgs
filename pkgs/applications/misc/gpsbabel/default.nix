{ fetchurl, stdenv, zlib, expat, which }:

let version = "1.4.3"; in
stdenv.mkDerivation {
  name = "gpsbabel-${version}";

  src = fetchurl {
    # gpgbabel.org makes it hard to get the source tarball automatically, so
    # get it from elsewhere.
    url = "mirror://debian/pool/main/g/gpsbabel/gpsbabel_${version}.orig.tar.gz";
    sha256 = "1s31xa36ivf836h89m1f3qiaz3c3znvqjdm0bnh8vr2jjlrz9jdi";
  };

  # FIXME: Would need libxml2 for one of the tests, but that in turns require
  # network access for the XML schemas.
  buildInputs = [ zlib expat which ];

  /* FIXME: Building the documentation, with "make doc", requires this:

      [ libxml2 libxslt perl docbook_xml_dtd_412 docbook_xsl fop ]

    But FOP isn't packaged yet.  */

  preConfigure = "cd gpsbabel";
  configureFlags = [ "--with-zlib=system" ];

  doCheck = true;

  meta = {
    description = "GPSBabel, a tool to convert, upload and download data from GPS and Map programs";

    longDescription = ''
      GPSBabel converts waypoints, tracks, and routes between popular
      GPS receivers and mapping programs.  It also has powerful
      manipulation tools for such data.

      By flattening the Tower of Babel that the authors of various
      programs for manipulating GPS data have imposed upon us, it
      returns to us the ability to freely move our own waypoint data
      between the programs and hardware we choose to use.

      It contains extensive data manipulation abilities making it a
      convenient for server-side processing or as the backend for
      other tools.

      It does not convert, transfer, send, or manipulate maps.  We
      process data that may (or may not be) placed on a map, such as
      waypoints, tracks, and routes.
    '';

    homepage = http://www.gpsbabel.org/;

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;         # arbitrary choice
  };
}

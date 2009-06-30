{ fetchurl, stdenv, zlib, expat }:

stdenv.mkDerivation rec {
  name = "gpsbabel-1.3.6";

  src = fetchurl {
    url = "http://www.gpsbabel.org/plan9.php?dl=${name}.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1dm9lpcdsj0vz699zz932xc1vphvap627wl0qp61izlkzh25vg88";
  };

  buildInputs = [ zlib expat ];

  /* FIXME: Building the documentation, with "make doc", requires this:

      [ libxml2 libxslt perl docbook_xml_dtd_412 docbook_xsl fop ]

    But FOP isn't packaged yet.  */

  configureFlags = "--with-zlib=system";

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

    license = "GPLv2+";
  };
}

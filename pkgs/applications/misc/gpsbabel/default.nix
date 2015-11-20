{ stdenv, fetchurl, zlib, qt5, which }:

stdenv.mkDerivation rec {
  name = "gpsbabel-${version}";
  version = "1.5.2";

  src = fetchurl {
    # gpgbabel.org makes it hard to get the source tarball automatically, so
    # get it from elsewhere.
    url = "mirror://debian/pool/main/g/gpsbabel/gpsbabel_${version}.orig.tar.gz";
    sha256 = "0xf7wmy2m29g2lm8lqc74yf8rf7sxfl3cfwbk7dpf0yf42pb0b6w";
  };

  buildInputs = [ zlib qt5.base which ];

  /* FIXME: Building the documentation, with "make doc", requires this:

      [ libxml2 libxslt perl docbook_xml_dtd_412 docbook_xsl fop ]

    But FOP isn't packaged yet.  */

  preConfigure = "cd gpsbabel";
  configureFlags = [ "--with-zlib=system" ];

  doCheck = true;
  preCheck = ''
    patchShebangs testo
    substituteInPlace testo \
      --replace "-x /usr/bin/hexdump" ""
  '';

  meta = with stdenv.lib; {
    description = "Convert, upload and download data from GPS and Map programs";
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
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}

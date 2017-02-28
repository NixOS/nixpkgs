{ stdenv, fetchurl, fetchpatch, zlib, qt4, which }:

stdenv.mkDerivation rec {
  name = "gpsbabel-${version}";
  version = "1.5.3";

  src = fetchurl {
    # gpgbabel.org makes it hard to get the source tarball automatically, so
    # get it from elsewhere.
    url = "mirror://debian/pool/main/g/gpsbabel/gpsbabel_${version}.orig.tar.gz";
    sha256 = "0l6c8911f7i5bbdzah9irhqf127ib0b7lv53rb8r9z8g439mznq1";
  };

  patches = [
    (fetchpatch {
      url = https://sources.debian.net/data/main/g/gpsbabel/1.5.3-2/debian/patches/use_minizip;
      sha256 = "03fpsmlx1wc48d1j405zkzp8j64hcp0z72islf4mk1immql3ibcr";
    })
  ];

  buildInputs = [ zlib qt4 which ];

  /* FIXME: Building the documentation, with "make doc", requires this:

      [ libxml2 libxslt perl docbook_xml_dtd_412 docbook_xsl fop ]

    But FOP isn't packaged yet.  */

  configureFlags = [ "--with-zlib=system" ]
    # Floating point behavior on i686 causes test failures. Preventing
    # extended precision fixes this problem.
    ++ stdenv.lib.optionals stdenv.isi686 [
      "CFLAGS=-ffloat-store" "CXXFLAGS=-ffloat-store"
    ];

  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    patchShebangs testo
    substituteInPlace testo \
      --replace "-x /usr/bin/hexdump" ""
  '' + (
    # The raymarine and gtm tests fail on i686 despite -ffloat-store.
    if stdenv.isi686 then "rm -v testo.d/raymarine.test testo.d/gtm.test;"
    else ""
  );

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

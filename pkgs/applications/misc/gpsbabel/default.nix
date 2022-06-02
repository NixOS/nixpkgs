{ lib, stdenv, fetchFromGitHub, fetchpatch, libusb1, qtbase, zlib, IOKit, which, expat }:

stdenv.mkDerivation rec {
  pname = "gpsbabel";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gpsbabel";
    repo = "gpsbabel";
    rev = "gpsbabel_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "010g0vd2f5knpq5p7qfnl31kv3r8m5sjdsafcinbj5gh02j2nzpy";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/g/gpsbabel/1.5.3-2/debian/patches/use_minizip";
      sha256 = "03fpsmlx1wc48d1j405zkzp8j64hcp0z72islf4mk1immql3ibcr";
    })
  ];

  buildInputs = [ libusb1 qtbase zlib ]
    ++ lib.optionals stdenv.isDarwin [ IOKit ];

  checkInputs = [ expat.dev which ]; # Avoid ./testo.d/kml.test: line 74: which: command not found. Skipping KML validation phase.

  /* FIXME: Building the documentation, with "make doc", requires this:

      [ libxml2 libxslt perl docbook_xml_dtd_412 docbook_xsl fop ]

    But FOP isn't packaged yet.  */

  configureFlags = [ "--with-zlib=system" ]
    # Floating point behavior on i686 causes test failures. Preventing
    # extended precision fixes this problem.
    ++ lib.optionals stdenv.isi686 [
      "CFLAGS=-ffloat-store" "CXXFLAGS=-ffloat-store"
    ];

  enableParallelBuilding = true;

  dontWrapQtApps = true;

  doCheck = true;
  preCheck = ''
    patchShebangs testo
    substituteInPlace testo \
      --replace "-x /usr/bin/hexdump" ""

    rm -v testo.d/alantrl.test
  ''
    # The raymarine and gtm tests fail on i686 despite -ffloat-store.
  + lib.optionalString stdenv.isi686 "rm -v testo.d/raymarine.test testo.d/gtm.test;"
    # The gtm, kml and tomtom asc tests fail on darwin, see PR #23572.
  + lib.optionalString stdenv.isDarwin "rm -v testo.d/gtm.test testo.d/kml.test testo.d/tomtom_asc.test testo.d/classic-2.test"
    # The arc-project test fails on aarch64.
  + lib.optionalString stdenv.isAarch64 "rm -v testo.d/arc-project.test";

  meta = with lib; {
    broken = stdenv.isDarwin;
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
    homepage = "http://www.gpsbabel.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}

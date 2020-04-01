{ fetchurl, fetchpatch, stdenv, makeWrapper
, pkgconfig, intltool, gettext, gtk2, expat, curl
, gpsd, bc, file, gnome-doc-utils, libexif, libxml2, libxslt, scrollkeeper
, docbook_xml_dtd_412, gexiv2, gpsbabel, expect
, withMapnik ? false, mapnik
, withMBTiles ? true, sqlite
, withOAuth ? true, liboauth
, withMd5Hash ? true, nettle
, withGeoClue ? true, geoclue2 }:

stdenv.mkDerivation rec {
  pname = "viking";
  version = "1.8";

  src = fetchurl {
    url = "mirror://sourceforge/viking/viking/viking-${version}.tar.bz2";
    sha256 = "1a0g0fbj4q5s9p8fv0mqvxws10q3naj81l72sz30vvqpbz6vqp45";
  };

  patches = [
    # Fix build without mapnik and sqlite https://github.com/viking-gps/viking/pull/79
    (fetchpatch {
      url = "https://github.com/viking-gps/viking/commit/995feefcb97bdb1590ed018224cf47ce197fe0c1.patch";
      sha256 = "1xb0b76kg690fag9mw3yfj5k766jmqp1sm8q4f29n1h3nz5g8izd";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ makeWrapper intltool gettext gtk2 expat curl gpsd bc file gnome-doc-utils
    libexif libxml2 libxslt scrollkeeper docbook_xml_dtd_412 gexiv2
  ] ++ stdenv.lib.optional withMapnik mapnik
    ++ stdenv.lib.optional withGeoClue geoclue2
    ++ stdenv.lib.optional withMd5Hash nettle
    ++ stdenv.lib.optional withOAuth liboauth
    ++ stdenv.lib.optional withMBTiles sqlite;

  configureFlags = [
    "--disable-scrollkeeper"
    (stdenv.lib.enableFeature withMapnik "mapnik")
    (stdenv.lib.enableFeature withGeoClue "geoclue")
    (stdenv.lib.enableFeature withMd5Hash "nettle")
    (stdenv.lib.enableFeature withOAuth "oauth")
    (stdenv.lib.enableFeature withMBTiles "mbtiles")
  ];

  preBuild = ''
    sed -i help/Makefile \
        -e 's|--noout|--noout --nonet --path "${scrollkeeper}/share/xml/scrollkeeper/dtds"|g'
    sed -i help/Makefile -e 's|--postvalid||g'
  '';

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/viking \
      --prefix PATH : "${gpsbabel}/bin" \
      --prefix PATH : "${expect}/bin"
  '';

  meta = with stdenv.lib; {
    description = "GPS data editor and analyzer";
    longDescription = ''
      Viking is a free/open source program to manage GPS data.  You
      can import and plot tracks and waypoints, show Openstreetmaps
      and/or Terraserver maps under it, download geocaches for an area
      on the map, make new tracks and waypoints, see real-time GPS
      position, etc.
    '';
    homepage = https://sourceforge.net/projects/viking/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub sikmir ];
    platforms = with platforms; linux;
  };
}

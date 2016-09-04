{ fetchurl, stdenv, makeWrapper, pkgconfig, intltool, gettext, gtk, expat, curl
, gpsd, bc, file, gnome_doc_utils, libexif, libxml2, libxslt, scrollkeeper
, docbook_xml_dtd_412, gexiv2, sqlite, gpsbabel, expect }:

stdenv.mkDerivation rec {
  name = "viking-${version}";
  version = "1.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/viking/viking/viking-${version}.tar.bz2";
    sha256 = "09kq0sxs2czps0d6xzgkkp41746v44ip63m72qvfs7rsrnqj7qnz";
  };

  buildInputs = [ makeWrapper pkgconfig intltool gettext gtk expat curl gpsd bc file gnome_doc_utils
    libexif libxml2 libxslt scrollkeeper docbook_xml_dtd_412 gexiv2 sqlite
  ];

  configureFlags = [ "--disable-scrollkeeper --disable-mapnik" ];

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
    homepage = http://viking.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}

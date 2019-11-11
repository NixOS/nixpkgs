{ fetchurl, stdenv, makeWrapper, pkgconfig, intltool, gettext, gtk2, expat, curl
, gpsd, bc, file, gnome-doc-utils, libexif, libxml2, libxslt, scrollkeeper
, docbook_xml_dtd_412, gexiv2, sqlite, gpsbabel, expect
, geoclue2, liboauth, nettle }:

stdenv.mkDerivation rec {
  pname = "viking";
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/viking/viking/viking-${version}.tar.bz2";
    sha256 = "092q2dv0rcz12nh2js1z1ralib1553dmzy9pdrvz9nv2vf61wybw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ makeWrapper intltool gettext gtk2 expat curl gpsd bc file gnome-doc-utils
    libexif libxml2 libxslt scrollkeeper docbook_xml_dtd_412 gexiv2 sqlite
    geoclue2 liboauth nettle
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
    homepage = https://sourceforge.net/projects/viking/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}

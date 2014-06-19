{ fetchurl, stdenv, pkgconfig, intltool, gettext, gtk, expat, curl
, gpsd, bc, file, gnome_doc_utils, libexif, libxml2, libxslt, scrollkeeper
, docbook_xml_dtd_412 }:

let version = "1.3"; in
stdenv.mkDerivation {
  name = "viking-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/viking/viking/${version}/viking-${version}.tar.gz";
    sha256 = "1psgy1myx9xn7zgpvqrpricsv041sz41mm82hj5i28k72fq47p2l";
  };

  buildInputs =
   [ pkgconfig intltool gettext gtk expat curl gpsd bc file gnome_doc_utils
     libexif libxml2 libxslt scrollkeeper docbook_xml_dtd_412
   ];

  configureFlags = [ "--disable-scrollkeeper" ];

  preBuild =
    '' sed -i help/Makefile \
           -e 's|--noout|--noout --nonet --path "${scrollkeeper}/share/xml/scrollkeeper/dtds"|g'
    '';

  doCheck = true;

  meta = {
    description = "Viking, a GPS data editor and analyzer";

    longDescription = ''
      Viking is a free/open source program to manage GPS data.  You
      can import and plot tracks and waypoints, show Openstreetmaps
      and/or Terraserver maps under it, download geocaches for an area
      on the map, make new tracks and waypoints, see real-time GPS
      position, etc.
    '';

    homepage = http://viking.sourceforge.net/;

    license = stdenv.lib.licenses.gpl2Plus;
  };
}

{ fetchurl, stdenv, pkgconfig, gettext, gtk, gconf
, curl, libexif, sqlite }:

stdenv.mkDerivation rec {
  name = "tangogps-0.9.6";

  src = fetchurl {
    url = "http://www.tangogps.org/downloads/${name}.tar.gz";
    sha256 = "04vfbr7skjcfadv9206q2pxbm74i8yypkjwzldsc5a6ybhr7fsp5";
  };

  buildInputs = [ pkgconfig gettext gtk gconf curl libexif sqlite ];

  meta = {
    description = "tangoGPS, a user friendly map and GPS user interface";

    longDescription = ''
      tangoGPS is an easy to use, fast and lightweight mapping
      application for use with or without GPS.

      It runs on any Linux platform from the desktop over eeePC down
      to phones like the Openmoko Neo.

      By default tangoGPS uses map data from the OpenStreetMap
      project.  Additionally a variety of other repositories can be
      easily added.

      The maps are automagically downloaded and cached for offline use
      while you drag or zoom the map.  Furthermore you can
      conveniently pre-cache areas with tangoGPS.
    '';

    homepage = http://www.tangogps.org/;

    license = "GPLv2+";
  };
}

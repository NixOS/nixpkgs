{ fetchurl, stdenv, pkgconfig, intltool, gettext, gtk, expat, curl
, gpsd, bc, file }:

stdenv.mkDerivation rec {
  name = "viking-0.9.8";

  src = fetchurl {
    url = "mirror://sourceforge/viking/${name}.tar.gz";
    sha256 = "1is8g6ld5pd13iiv9qm8526q1cblg01pqyakg52sd6k7fys7dz2d";
  };

  patches = [
    ./test-bc.patch ./gpsdclient.patch ./implicit-declaration.patch
  ];

  buildInputs = [ pkgconfig intltool gettext gtk expat curl gpsd bc file ];

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

    license = "GPLv2+";
  };
}

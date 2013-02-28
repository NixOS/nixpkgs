{ fetchurl, stdenv, pkgconfig, gettext, gtk, gconf
, curl, libexif, sqlite, libxml2 }:

stdenv.mkDerivation rec {
  name = "tangogps-0.99.2";

  src = fetchurl {
    url = "http://www.tangogps.org/downloads/${name}.tar.gz";
    sha256 = "15q2kkrv4mfsivfdzjgpxr7s2amw7d501q2ayjl3ff4vmvfn5516";
  };

  buildInputs = [ pkgconfig gettext gtk gconf curl libexif sqlite libxml2 ];

  # bogus includes fail with newer library version
  postPatch = ''
    sed -i -e 's,#include <glib/.*>,#include <glib.h>,g' src/*.c
    sed -i -e 's,#include <curl/.*>,#include <curl/curl.h>,g' src/*.c src/*.h
  '';

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

    #homepage = http://www.tangogps.org/; # no longer valid, I couldn't find any other

    license = "GPLv2+";
  };
}

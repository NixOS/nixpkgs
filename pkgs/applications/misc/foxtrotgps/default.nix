{ lib, stdenv, fetchbzr, autoreconfHook, texinfo, help2man, imagemagick, pkg-config
, curl, gnome2, gpsd, gtk2, wrapGAppsHook
, intltool, libexif, python3Packages, sqlite }:

let
  srcs = {
    foxtrot = fetchbzr {
      url = "lp:foxtrotgps";
      rev = "329";
      sha256 = "0fwgnsrah63h1xdgm5xdi5ancrz89shdp5sdzw1qc1m7i9a03rid";
    };
    screenshots = fetchbzr {
      url = "lp:foxtrotgps/screenshots";
      rev = "2";
      sha256 = "1sgysn3dhfhrv7rj7wf8f2119vmhc1s1zzsp4r3nlrr45d20wmsv";
    };
  };
in stdenv.mkDerivation rec {
  pname = "foxtrotgps";
  version = "1.2.2+329";

  # Pull directly from bzr because gpsd API version 9 is not supported on latest release
  src = srcs.foxtrot;

  nativeBuildInputs = [
    pkg-config autoreconfHook texinfo help2man
    imagemagick wrapGAppsHook intltool
  ];

  buildInputs = [
    curl.dev
    gnome2.libglade.dev
    gpsd
    gtk2.dev
    libexif
    sqlite.dev
    (python3Packages.python.withPackages (pythonPackages: with python3Packages;
    [ beautifulsoup4 feedparser sqlalchemy ]))
  ];

  postUnpack = ''
  cp -R ${srcs.screenshots} $sourceRoot/doc/screenshots
  chmod -R u+w $sourceRoot/doc/screenshots
  '';

  preConfigure = ''
  intltoolize --automake --copy --force
  '';

  meta = with lib; {
    description = "GPS/GIS application optimized for small screens";
    longDescription = ''
      An easy to use, free & open-source GPS/GIS application that works well on
      small screens, and is especially suited to touch input. It spun off of
      tangoGPS in 2010 with a focus on cooperation and fostering community
      innovation.
    '';
    homepage = "https://www.foxtrotgps.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wucke13 ];
  };
}

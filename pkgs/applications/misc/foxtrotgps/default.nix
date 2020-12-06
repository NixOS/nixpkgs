{ stdenv, fetchbzr, autoreconfHook, texinfo, help2man, imagemagick, pkg-config
, curl, gnome2, gpsd, gtk2, wrapGAppsHook
, intltool, libexif, python3Packages, sqlite }:

let
  srcs = {
    foxtrot = fetchbzr {
      url = "lp:foxtrotgps";
      rev = "326";
      sha256 = "191pgcy5rng8djy22a5z9s8gssc73f9p5hm4ig52ra189cb48d8k";
    };
    screenshots = fetchbzr {
      url = "lp:foxtrotgps/screenshots";
      rev = "2";
      sha256 = "1sgysn3dhfhrv7rj7wf8f2119vmhc1s1zzsp4r3nlrr45d20wmsv";
    };
  };
in stdenv.mkDerivation rec {
  pname = "foxtrotgps";
  version = "1.2.2+326";

  # Pull directly from bzr because gpsd API version 9 is not supported on latest release
  src = srcs.foxtrot;

  patches = [
    ./gps-status-fix.patch
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook texinfo help2man imagemagick wrapGAppsHook ];

  buildInputs = [
    curl.dev
    gnome2.libglade.dev
    gpsd
    gtk2.dev
    intltool
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

  meta = with stdenv.lib; {
    description = "GPS/GIS application optimized for small screens";
    longDescription = ''
      An easy to use, free & open-source GPS/GIS application that works well on
      small screens, and is especially suited to touch input. It spun off of
      tangoGPS in 2010 with a focus on cooperation and fostering community
      innovation.
    '';
    homepage = "https://www.foxtrotgps.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wucke13 ];
  };
}

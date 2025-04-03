{
  lib,
  stdenv,
  fetchbzr,
  autoreconfHook,
  texinfo,
  help2man,
  imagemagick,
  pkg-config,
  curl,
  gnome2,
  gpsd,
  gtk2,
  wrapGAppsHook3,
  intltool,
  libexif,
  python3Packages,
  sqlite,
}:

let
  srcs = {
    foxtrot = fetchbzr {
      url = "lp:foxtrotgps";
      rev = "331";
      sha256 = "sha256-/kJv6a3MzAzzwIl98Mqi7jrUJC1kDvouigf9kGtv868=";
    };
    screenshots = fetchbzr {
      url = "lp:foxtrotgps/screenshots";
      rev = "2";
      sha256 = "1sgysn3dhfhrv7rj7wf8f2119vmhc1s1zzsp4r3nlrr45d20wmsv";
    };
  };
in
stdenv.mkDerivation {
  pname = "foxtrotgps";
  version = "1.2.2+331";

  # Pull directly from bzr because gpsd API version 9 is not supported on latest release
  src = srcs.foxtrot;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    texinfo
    help2man
    imagemagick
    wrapGAppsHook3
    intltool
  ];

  buildInputs = [
    curl.dev
    gnome2.libglade.dev
    gpsd
    gtk2.dev
    libexif
    sqlite.dev
    (python3Packages.python.withPackages (
      pythonPackages: with python3Packages; [
        beautifulsoup4
        feedparser
        sqlalchemy
      ]
    ))
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  postUnpack = ''
    cp -R ${srcs.screenshots} $sourceRoot/doc/screenshots
    chmod -R u+w $sourceRoot/doc/screenshots
  '';

  # Remove when foxtrotgps supports gpsd 3.23.1
  # Patch for compatibility with gpsd 3.23.1. This was added for foxtrotgps
  # 1.2.2+331. The command can be removed if the build of a newer version
  # succeeds without it.
  postPatch = ''
    substituteInPlace src/gps_functions.c --replace "STATUS_NO_FIX" "STATUS_UNK"
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

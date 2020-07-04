{ fetchurl, stdenv, pkg-config, wrapGAppsHook, curl, gnome2, gpsd, gtk2
, intltool, libexif, python3Packages, sqlite }:

stdenv.mkDerivation rec {
  pname = "foxtrotgps";
  version = "1.2.2";

  src = fetchurl {
    url = "https://www.foxtrotgps.org/releases/foxtrotgps-${version}.tar.xz";
    sha256 = "0grn35j5kwc286dxx18fv32qa330xmalqliwy6zirxmj6dffvrkg";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

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

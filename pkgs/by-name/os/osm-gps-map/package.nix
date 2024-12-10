{
  cairo,
  fetchzip,
  glib,
  libsoup,
  gnome-common,
  gtk3,
  gobject-introspection,
  pkg-config,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "osm-gps-map";
  version = "1.2.0";

  src = fetchzip {
    url = "https://github.com/nzjrs/osm-gps-map/releases/download/${version}/osm-gps-map-${version}.tar.gz";
    sha256 = "sha256-ciw28YXhR+GC6B2VPC+ZxjyhadOk3zYGuOssSgqjwH0=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    gnome-common
  ];

  buildInputs = [
    cairo
    glib
    gtk3
    libsoup
  ];

  meta = with lib; {
    description = "GTK widget for displaying OpenStreetMap tiles";
    homepage = "https://nzjrs.github.io/osm-gps-map";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

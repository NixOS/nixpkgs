{
  cairo,
  fetchzip,
  glib,
  libsoup_2_4,
  gnome-common,
  gtk3,
  gobject-introspection,
  pkg-config,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm-gps-map";
  version = "1.2.0";

  src = fetchzip {
    url = "https://github.com/nzjrs/osm-gps-map/releases/download/${finalAttrs.version}/osm-gps-map-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-ciw28YXhR+GC6B2VPC+ZxjyhadOk3zYGuOssSgqjwH0=";
  };

  patches = [
    # libsoup is only used internally
    # it should only be listed as private requirement
    # https://github.com/nzjrs/osm-gps-map/pull/108
    ./dont-require-libsoup.patch
  ];

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
    libsoup_2_4
  ];

  propagatedBuildInputs = [
    gtk3
  ];

  meta = {
    description = "GTK widget for displaying OpenStreetMap tiles";
    homepage = "https://nzjrs.github.io/osm-gps-map";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hrdinka ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

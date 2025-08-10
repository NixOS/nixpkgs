{
  cairo,
  fetchFromGitHub,
  glib,
  libsoup_3,
  gnome-common,
  gtk3,
  gobject-introspection,
  pkg-config,
  lib,
  stdenv,
  autoconf,
  automake,
  gtk-doc,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm-gps-map";
  version = "unstable-2025-04-17";

  src = fetchFromGitHub {
    owner = "nzjrs";
    repo = "osm-gps-map";
    rev = "2396aa6cb2da877847049e7f4243a7d196f9862e";
    hash = "sha256-HAOzjPBoC/zpgIo09GYVlR98GNKqWkJ6117Ttqlr/bw=";
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
    autoconf
    automake
    gobject-introspection
    gnome-common
  ];

  buildInputs = [
    cairo
    glib
    libsoup_3
    gtk-doc
    libtool
  ];

  preConfigure = "./autogen.sh";

  propagatedBuildInputs = [
    gtk3
  ];

  meta = {
    description = "GTK widget for displaying OpenStreetMap tiles";
    homepage = "https://nzjrs.github.io/osm-gps-map";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      hrdinka
      cafkafk
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

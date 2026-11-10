{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  glib,
  gtk-doc,
  gtk ? gtk3,
  gtk3,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "gtk-mac-integration";
  version = "3.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gtk-mac-integration";
    rev = "gtk-mac-integration-${version}";
    hash = "sha256-6k0pikco+6/XIB4A5Ej0qffopjivnUZiga6XjO6ogGk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gtk-doc
    gobject-introspection
  ];
  buildInputs = [ glib ];
  propagatedBuildInputs = [ gtk ];

  preAutoreconf = ''
    gtkdocize
  '';

  meta = {
    description = "Provides integration for GTK applications into the Mac desktop";
    license = lib.licenses.lgpl21;
    homepage = "https://gitlab.gnome.org/GNOME/gtk-mac-integration";
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}

{
  stdenv,
  lib,
  meson,
  ninja,
  fetchFromGitLab,
  pkg-config,
  glib,
  docbook_xsl,
  sane-backends,
  gobject-introspection,
  vala,
  gtk-doc,
  valgrind,
  doxygen,
  cunit,
}:

stdenv.mkDerivation rec {
  pname = "libinsane";
  version = "1.0.10";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "libinsane";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "sha256-2BLg8zB0InPJqK9JypQIMVXIJndo9ZuNB4OeOAo/Hsc=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    doxygen
    gtk-doc
    docbook_xsl
    gobject-introspection
    vala
  ];

  buildInputs = [
    sane-backends
    glib
  ];

  nativeCheckInputs = [
    cunit
    valgrind
  ];

  doCheck = true;

  meta = {
    description = "Crossplatform access to image scanners (paper eaters only)";
    homepage = "https://openpaper.work/en/projects/";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.symphorien ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  gtk-doc,
  gdk-pixbuf,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdk-pixbuf-xlib";
  version = "2.40.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "gdk-pixbuf-xlib";
    rev = finalAttrs.version;
    hash = "sha256-b4EUaYzg2NlBMU90dGQivOvkv9KKSzES/ymPqzrelu8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    docbook-xsl-nons
    docbook_xml_dtd_43
    gtk-doc
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    libx11
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  meta = {
    description = "Deprecated API for integrating GdkPixbuf with Xlib data types";
    homepage = "https://gitlab.gnome.org/Archive/gdk-pixbuf-xlib";
    maintainers = [ ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})

{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  glib,
  libxml2,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gupnp-av";
  version = "0.14.3";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-av/${lib.versions.majorMinor version}/gupnp-av-${version}.tar.xz";
    sha256 = "q+IEYEPmapUpNl2JBZvhIhnCGk7eDEdDcDsP2arxe7Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  propagatedBuildInputs = [
    glib
    libxml2
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=deprecated-declarations"
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gupnp-av";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "http://gupnp.org/";
    description = "Collection of helpers for building AV (audio/video) applications using GUPnP";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}

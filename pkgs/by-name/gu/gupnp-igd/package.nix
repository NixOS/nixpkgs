{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gettext,
  gobject-introspection,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_412,
  glib,
  gupnp_1_6,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gupnp-igd";
  version = "1.6.0";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-igd/${lib.versions.majorMinor finalAttrs.version}/gupnp-igd-${finalAttrs.version}.tar.xz";
    hash = "sha256-QJmXgzmrIhJtSWjyozK20JT8RMeHl4YHgfH8LxF3G3Q=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  propagatedBuildInputs = [
    glib
    gupnp_1_6
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
    "-Dintrospection=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
  ];

  # Seems to get stuck sometimes.
  # https://github.com/NixOS/nixpkgs/issues/119288
  # doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gupnp-igd";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Library to handle UPnP IGD port mapping";
    homepage = "http://www.gupnp.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})

{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gi-docgen,
  gobject-introspection,
  vala,
  glib,
  libxml2,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gupnp-av";
  version = "0.14.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-av/${lib.versions.majorMinor finalAttrs.version}/gupnp-av-${finalAttrs.version}.tar.xz";
    sha256 = "Idl0sydctdz1uKodmj/IDn7cpwaTX2+9AEx5eHE4+Mc=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [
    glib
    libxml2
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc/gupnp-av-1.0" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gupnp-av";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    homepage = "http://gupnp.org/";
    description = "Collection of helpers for building AV (audio/video) applications using GUPnP";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})

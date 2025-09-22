{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  desktop-file-utils,
  meson,
  ninja,
  vala,
  libxslt,
  pkg-config,
  glib,
  gtk3,
  libhandy,
  gnome,
  dconf,
  libxml2,
  gettext,
  docbook-xsl-nons,
  wrapGAppsHook3,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "dconf-editor";
  version = "45.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf-editor/${lib.versions.major version}/dconf-editor-${version}.tar.xz";
    hash = "sha256-EYApdnju2uYhfMUUomOMGH0vHR7ycgy5B5t0DEKZQd0=";
  };

  patches = [
    # Fix crash with GSETTINGS_SCHEMA_DIR env var.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/dconf-editor/-/commit/baf183737d459dcde065c9f8f6fe5be7ed874de6.patch";
      hash = "sha256-Vp0qjJChDr6IarUD+tZPLJhdI8v8r6EzWNfqFSnGvqQ=";
    })

    # Look for compiled schemas in NIX_GSETTINGS_OVERRIDES_DIR
    # environment variable, to match what we patched GLib to do.
    ./schema-override-variable.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    vala
    libxslt
    pkg-config
    wrapGAppsHook3
    gettext
    docbook-xsl-nons
    libxml2
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    dconf
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "dconf-editor";
    };
  };

  meta = {
    description = "GSettings editor for GNOME";
    mainProgram = "dconf-editor";
    homepage = "https://apps.gnome.org/DconfEditor/";
    changelog = "https://gitlab.gnome.org/GNOME/dconf-editor/-/blob/${version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
}

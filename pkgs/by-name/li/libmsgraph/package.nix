{
  stdenv,
  lib,
  fetchurl,
  gi-docgen,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  uhttpmock_1_0,
  libxml2,
  glib,
  gnome-online-accounts,
  json-glib,
  libsoup_3,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmsgraph";
  version = "0.3.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/msgraph/${lib.versions.majorMinor finalAttrs.version}/msgraph-${finalAttrs.version}.tar.xz";
    hash = "sha256-BzHs5rArMu7/u72Y79x3vAPd0gZR7q46Q0Pwh5sE1sc=";
  };

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    uhttpmock_1_0
    libxml2
  ];

  propagatedBuildInputs = [
    glib
    gnome-online-accounts
    json-glib
    libsoup_3
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc/msgraph-1" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libmsgraph";
      packageName = "msgraph";
    };
  };

  meta = {
    description = "Library to access MS Graph API for Office 365";
    homepage = "https://gitlab.gnome.org/GNOME/msgraph";
    changelog = "https://gitlab.gnome.org/GNOME/msgraph/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.lgpl3Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})

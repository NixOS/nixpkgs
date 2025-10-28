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
  version = "0.3.3";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/msgraph/${lib.versions.majorMinor finalAttrs.version}/msgraph-${finalAttrs.version}.tar.xz";
    hash = "sha256-N9fhLyqZBJCuohGE8LJ+C5Feu05QlvTWYyxiBRwFQBI=";
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

  meta = with lib; {
    description = "Library to access MS Graph API for Office 365";
    homepage = "https://gitlab.gnome.org/GNOME/msgraph";
    changelog = "https://gitlab.gnome.org/GNOME/msgraph/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.lgpl3Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})

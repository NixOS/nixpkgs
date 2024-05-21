{ stdenv
, lib
, fetchurl
, gi-docgen
, gobject-introspection
, meson
, ninja
, pkg-config
, uhttpmock_1_0
, glib
, gnome-online-accounts
, json-glib
, librest_1_0
, libsoup_3
, gnome
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmsgraph";
  version = "0.2.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/msgraph/${lib.versions.majorMinor finalAttrs.version}/msgraph-${finalAttrs.version}.tar.xz";
    hash = "sha256-4OWeqorj4KSOwKbC/tBHCFanCSSOkhK2odA33leS7Ls=";
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
  ];

  propagatedBuildInputs = [
    glib
    gnome-online-accounts
    json-glib
    librest_1_0
    libsoup_3
  ];

  mesonFlags = [
    # https://gitlab.gnome.org/GNOME/msgraph/-/merge_requests/9
    "-Dc_args=-Wno-error=format-security"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc/msgraph-0" "$devdoc"
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
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})

{ stdenv
, lib
, fetchFromGitLab
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmsgraph";
  version = "0.1.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "msgraph";
    rev = finalAttrs.version;
    hash = "sha256-UH8qJxOrJL7gqR1QDQJ+HQ1u3tA3TcSZMluAOSSC40I=";
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

  meta = with lib; {
    description = "Library to access MS Graph API for Office 365";
    homepage = "https://gitlab.gnome.org/GNOME/msgraph";
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})

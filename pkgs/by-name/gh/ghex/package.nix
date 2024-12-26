{ stdenv
, lib
, fetchurl
, pkg-config
, gi-docgen
, meson
, ninja
, gnome
, desktop-file-utils
, appstream-glib
, gettext
, itstool
, gtk4
, libadwaita
, glib
, atk
, gobject-introspection
, vala
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "ghex";
  version = "46.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${lib.versions.major version}/ghex-${version}.tar.xz";
    hash = "sha256-ihOXVHTu4ncZsprXY/GyR2Chrt5tfaS2I3AwcLwm6f0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    atk
    glib
  ];

  nativeCheckInputs = [
    appstream-glib
    desktop-file-utils
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dvapi=true"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # mremap does not exist on darwin
    "-Dmmap-buffer-backend=false"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "ghex";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/ghex";
    changelog = "https://gitlab.gnome.org/GNOME/ghex/-/blob/${version}/NEWS?ref_type=tags";
    description = "Hex editor for GNOME desktop environment";
    mainProgram = "ghex";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
  };
}

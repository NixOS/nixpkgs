{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gnome
, adwaita-icon-theme
, gtk3
, wrapGAppsHook3
, glib
, gobject-introspection
, gi-docgen
, webkitgtk_4_1
, gettext
, itstool
, gsettings-desktop-schemas
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "devhelp";
  version = "43.0";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${lib.versions.major version}/devhelp-${version}.tar.xz";
    hash = "sha256-Y87u/QU5LgIESIHvHs1yQpNVPaVzW378CCstE/6F3QQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook3
    gobject-introspection
    gi-docgen
    # post install script
    glib
    gtk3
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk_4_1
    adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(
      # Fix pages being blank
      # https://gitlab.gnome.org/GNOME/devhelp/issues/14
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput share/doc/devhelp-3 "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "devhelp";
    };
  };

  meta = with lib; {
    description = "API documentation browser for GNOME";
    mainProgram = "devhelp";
    homepage = "https://apps.gnome.org/Devhelp/";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}

{ stdenv
, lib
, meson
, mesonEmulatorHook
, fetchurl
, python3
, pkg-config
, gtk3
, gtk-mac-integration
, glib
, tepl
, libgedit-amtk
, libgedit-gtksourceview
, libpeas
, libxml2
, gsettings-desktop-schemas
, wrapGAppsHook
, gtk-doc
, gobject-introspection
, docbook-xsl-nons
, ninja
, gnome
, gspell
, perl
, itstool
, desktop-file-utils
, vala
}:

stdenv.mkDerivation rec {
  pname = "gedit";
  version = "46.1";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${lib.versions.major version}/gedit-${version}.tar.xz";
    sha256 = "oabjfwQXZd/3InofVXi29J+q8Bax4X6GnK9b+5TGqk4=";
  };

  patches = [
    # We patch gobject-introspection and meson to store absolute paths to libraries in typelibs
    # but that requires the install_dir is an absolute path.
    ./correct-gir-lib-path.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    libxml2
    meson
    ninja
    perl
    pkg-config
    python3
    vala
    wrapGAppsHook
    gtk-doc
    gobject-introspection
    docbook-xsl-nons
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    tepl
    glib
    gsettings-desktop-schemas
    gspell
    gtk3
    libgedit-amtk
    libgedit-gtksourceview
    libpeas
  ] ++ lib.optionals stdenv.isDarwin [
    gtk-mac-integration
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    chmod +x plugins/externaltools/scripts/gedit-tool-merge.pl
    patchShebangs build-aux/meson/post_install.py
    patchShebangs plugins/externaltools/scripts/gedit-tool-merge.pl
  '';

  # Reliably fails to generate gedit-file-browser-enum-types.h in time
  enableParallelBuilding = false;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gedit";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Gedit";
    description = "Former GNOME text editor";
    maintainers = with maintainers; [ bobby285271 ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "gedit";
  };
}

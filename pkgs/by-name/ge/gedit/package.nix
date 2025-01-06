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
, libgedit-amtk
, libgedit-gtksourceview
, libgedit-tepl
, libpeas
, libxml2
, gsettings-desktop-schemas
, wrapGAppsHook3
, gtk-doc
, gobject-introspection
, docbook-xsl-nons
, ninja
, gnome
, gspell
, itstool
, desktop-file-utils
, vala
}:

stdenv.mkDerivation rec {
  pname = "gedit";
  version = "48.1";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${lib.versions.major version}/gedit-${version}.tar.xz";
    hash = "sha256-lx56wmvAo6Pe0np1Y3ckFWh9sOWgkrRUflsQpVhYswo=";
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
    pkg-config
    python3
    vala
    wrapGAppsHook3
    gtk-doc
    gobject-introspection
    docbook-xsl-nons
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gspell
    gtk3
    libgedit-amtk
    libgedit-gtksourceview
    libgedit-tepl
    libpeas
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gtk-mac-integration
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  # Reliably fails to generate gedit-file-browser-enum-types.h in time
  enableParallelBuilding = false;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gedit";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/gedit/gedit";
    description = "Former GNOME text editor";
    maintainers = with maintainers; [ bobby285271 ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "gedit";
  };
}

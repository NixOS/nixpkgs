{ stdenv
, lib
, meson
, mesonEmulatorHook
, fetchurl
, python3
, python3Packages
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
, perl
, itstool
, desktop-file-utils
, vala
}:

stdenv.mkDerivation rec {
  pname = "gedit";
  version = "47.0";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${lib.versions.major version}/gedit-${version}.tar.xz";
    sha256 = "+kpZfjTHbUrJFDG1rm4ZHJbGsK8XAuCJmrNRme36G/o=";
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
    python3Packages.wrapPython
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

  pythonPath = with python3Packages; [
    # https://github.com/NixOS/nixpkgs/issues/298716
    pycairo
  ];

  postFixup = ''
    buildPythonPath "$pythonPath"
    patchPythonScript $out/lib/gedit/plugins/snippets/document.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gedit";
    };
  };

  meta = with lib; {
    homepage = "https://gedit-technology.github.io/apps/gedit/";
    description = "Former GNOME text editor";
    maintainers = with maintainers; [ bobby285271 ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "gedit";
  };
}

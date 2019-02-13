{ stdenv, fetchFromGitHub, fetchpatch, libnotify, librsvg, killall
, gtk3, libappindicator-gtk3, substituteAll, syncthing, wrapGAppsHook
, gnome3, buildPythonApplication, dateutil, pyinotify, pygobject3
, bcrypt, gobject-introspection }:

buildPythonApplication rec {
  version = "0.9.4";
  name = "syncthing-gtk-${version}";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing-gtk";
    rev = "v${version}";
    sha256 = "0d3rjd1xjd7zravks9a2ph7gv1cm8wxaxkkvl1fvcx15v7f3hff9";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    # For setup hook populating GI_TYPELIB_PATH
    gobject-introspection
  ];

  buildInputs = [
    gtk3 librsvg libappindicator-gtk3
    libnotify gnome3.adwaita-icon-theme
    # Schemas with proxy configuration
    gnome3.gsettings-desktop-schemas
  ];

  propagatedBuildInputs = [
    dateutil pyinotify pygobject3 bcrypt
  ];

  patches = [
    (fetchpatch {
      url = https://github.com/syncthing/syncthing-gtk/commit/b2535e5a9cdb31c4987ab7af37f62d58d38255b7.patch;
      sha256 = "047v79wz2a9334gbzywlqwpacrk53s26ksvfqaddk06avv8742w7";
    })
    (substituteAll {
      src = ./paths.patch;
      killall = "${killall}/bin/killall";
      syncthing = "${syncthing}/bin/syncthing";
    })
  ];

  setupPyBuildFlags = [ "build_py" "--nofinddaemon" "--nostdownloader" ];

  postPatch = ''
    substituteInPlace setup.py --replace "version = get_version()" "version = '${version}'"
    substituteInPlace scripts/syncthing-gtk --replace "/usr/share" "$out/share"
    substituteInPlace syncthing_gtk/app.py --replace "/usr/share" "$out/share"
    substituteInPlace syncthing_gtk/uisettingsdialog.py --replace "/usr/share" "$out/share"
    substituteInPlace syncthing_gtk/wizard.py --replace "/usr/share" "$out/share"
    substituteInPlace syncthing-gtk.desktop --replace "/usr/bin/syncthing-gtk" "$out/bin/syncthing-gtk"
  '';

  meta = with stdenv.lib; {
    description = "GTK3 & python based GUI for Syncthing";
    homepage = https://github.com/syncthing/syncthing-gtk;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = syncthing.meta.platforms;
  };
}

{ stdenv, fetchFromGitHub, fetchpatch, libnotify, librsvg, killall
, gtk3, libappindicator-gtk3, substituteAll, syncthing, wrapGAppsHook
, gnome3, buildPythonApplication, dateutil, pyinotify, pygobject3
, bcrypt, gobject-introspection, gsettings-desktop-schemas
, pango, gdk-pixbuf, atk }:

buildPythonApplication rec {
  version = "0.9.4.4";
  pname = "syncthing-gtk";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing-gtk";
    rev = "v${version}";
    sha256 = "0nc0wd7qvyri7841c3dd9in5d7367hys0isyw8znv5fj4c0a6v1f";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    # For setup hook populating GI_TYPELIB_PATH
    gobject-introspection
    pango gdk-pixbuf atk libnotify
  ];

  buildInputs = [
    gtk3 librsvg libappindicator-gtk3
    libnotify gnome3.adwaita-icon-theme
    # Schemas with proxy configuration
    gsettings-desktop-schemas
  ];

  propagatedBuildInputs = [
    dateutil pyinotify pygobject3 bcrypt
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      killall = "${killall}/bin/killall";
      syncthing = "${syncthing}/bin/syncthing";
    })
  ];

  # repo doesn't have any tests
  doCheck = false;

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

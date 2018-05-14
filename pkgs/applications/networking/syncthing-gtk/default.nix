{ stdenv, fetchFromGitHub, libnotify, librsvg, darwin, psmisc, gtk3, libappindicator-gtk3, substituteAll, syncthing, wrapGAppsHook, gnome3, buildPythonApplication, dateutil, pyinotify, pygobject3, bcrypt, gobjectIntrospection }:

buildPythonApplication rec {
  version = "0.9.3.1";
  name = "syncthing-gtk-${version}";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing-gtk";
    rev = "v${version}";
    sha256 = "15bh9i0j0g7hrqsz22px8g2bg0xj4lsn81rziznh9fxxx5b9v9bb";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    # For setup hook populating GI_TYPELIB_PATH
    gobjectIntrospection
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
    ./disable-syncthing-binary-configuration.patch
    (substituteAll {
      src = ./paths.patch;
      killall = "${if stdenv.isDarwin then darwin.shell_cmds else psmisc}/bin/killall";
      syncthing = "${syncthing}/bin/syncthing";
    })
  ];

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
    maintainers = with maintainers; [ ];
    platforms = syncthing.meta.platforms;
    homepage = https://github.com/syncthing/syncthing-gtk;
    license = licenses.gpl2;
  };
}

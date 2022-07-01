{ lib, python3Packages, gobject-introspection, libappindicator-gtk3, libnotify, gtk3, gnome, xprintidle-ng, wrapGAppsHook, gdk-pixbuf, shared-mime-info, librsvg
}:

let inherit (python3Packages) python buildPythonApplication fetchPypi croniter;

in buildPythonApplication rec {
  pname = "safeeyes";
  version = "2.1.3";
  namePrefix = "";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b5w887hivmdrkm1ydbar4nmnks6grpbbpvxgf9j9s46msj03c9x";
  };

  buildInputs = [
    gtk3
    gobject-introspection
    gnome.adwaita-icon-theme
    gnome.adwaita-icon-theme
  ];

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    babel
    psutil
    xlib
    pygobject3
    dbus-python
    croniter

    libappindicator-gtk3
    libnotify
    xprintidle-ng
  ];

  # patch smartpause plugin
  postPatch = ''
    sed -i \
      -e 's!xprintidle!xprintidle-ng!g' \
      safeeyes/plugins/smartpause/plugin.py

    sed -i \
      -e 's!xprintidle!xprintidle-ng!g' \
      safeeyes/plugins/smartpause/config.json
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"

      # safeeyes images
      --prefix XDG_DATA_DIRS : "$out/lib/${python.libPrefix}/site-packages/usr/share"
    )
    mkdir -p $out/share/applications
    cp -r safeeyes/platform/icons $out/share/
    cp safeeyes/platform/safeeyes.desktop $out/share/applications/
  '';

  doCheck = false; # no tests

  meta = {
    homepage = "http://slgobinath.github.io/SafeEyes";
    description = "Protect your eyes from eye strain using this simple and beautiful, yet extensible break reminder. A Free and Open Source Linux alternative to EyeLeo";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ srghma ];
    platforms = lib.platforms.all;
  };
}

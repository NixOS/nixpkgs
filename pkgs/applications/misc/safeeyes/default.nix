{ lib, python3Packages, gobject-introspection, libappindicator-gtk3, libnotify, gtk3, gnome3, xprintidle-ng, wrapGAppsHook, gdk_pixbuf, shared-mime-info, librsvg
}:

let inherit (python3Packages) python buildPythonApplication fetchPypi;

in buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "safeeyes";
  version = "2.0.8.1";
  namePrefix = "";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x52ym8n4r6h38n4mcydxkvz71hhrd9wbiq4gzvwrai0xzl6qqsq";
  };

  buildInputs = [
    gtk3
    gobject-introspection
    gnome3.adwaita-icon-theme
    gnome3.adwaita-icon-theme
  ];

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    Babel
    psutil
    xlib
    pygobject3
    dbus-python

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
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"

      # safeeyes images
      --prefix XDG_DATA_DIRS : "$out/lib/${python.libPrefix}/site-packages/usr/share"
    )
  '';

  doCheck = false; # no tests

  meta = {
    homepage = http://slgobinath.github.io/SafeEyes;
    description = "Protect your eyes from eye strain using this simple and beautiful, yet extensible break reminder. A Free and Open Source Linux alternative to EyeLeo";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ srghma ];
    platforms = lib.platforms.all;
  };
}

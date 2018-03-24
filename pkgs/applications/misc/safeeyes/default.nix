{ lib, python3Packages, gobjectIntrospection, libappindicator-gtk3, gtk3, gnome3, xprintidle-ng
}:

let inherit (python3Packages) python buildPythonApplication fetchPypi;

in buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "safeeyes";
  version = "2.0.2";
  namePrefix = "";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fx6zd4hnbc7gdpac6r7smxwdl1bifaxx3mnx0wrqfvhpnwr1ybv";
  };

  buildInputs = [ gtk3 gobjectIntrospection gnome3.defaultIconTheme ];

  propagatedBuildInputs = with python3Packages; [
    Babel
    psutil
    xlib
    pygobject3
    dbus-python

    libappindicator-gtk3
    xprintidle-ng
  ];

  # patch smartpause plugin
  postPatch = ''
    sed -i \
      -e 's!xprintidle!${xprintidle-ng}/bin/xprintidle-ng!g' \
      safeeyes/plugins/smartpause/plugin.py

    sed -i \
      -e 's!xprintidle!${xprintidle-ng}/bin/xprintidle-ng!g' \
      safeeyes/plugins/smartpause/config.json
  '';

  doCheck = false;

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\""
    "--set GDK_PIXBUF_MODULE_FILE \"$GDK_PIXBUF_MODULE_FILE\""
    "--prefix XDG_DATA_DIRS : \"$out/lib/${python.libPrefix}/site-packages/usr/share\""
    "--suffix XDG_DATA_DIRS : \"$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\""
  ];

  meta = {
    homepage = http://slgobinath.github.io/SafeEyes;
    description = "Protect your eyes from eye strain using this simple and beautiful, yet extensible break reminder. A Free and Open Source Linux alternative to EyeLeo";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}

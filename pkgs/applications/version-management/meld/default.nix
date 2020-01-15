{ stdenv, fetchurl, itstool, python3, intltool, wrapGAppsHook
, libxml2, gobject-introspection, gtk3, gtksourceview, gnome3
, gsettings-desktop-schemas, dbus, xvfb_run
}:

python3.pkgs.buildPythonApplication rec {
  pname = "meld";
  version = "3.20.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0jdj7kd6vj1mdc16gvrj1kar88b2j5875ajq18fx7cbc9ny46j55";
  };

  nativeBuildInputs = [
    intltool itstool libxml2 gobject-introspection wrapGAppsHook
  ];
  buildInputs = [
    gtk3 gtksourceview gsettings-desktop-schemas gnome3.adwaita-icon-theme
    gobject-introspection # fixes https://github.com/NixOS/nixpkgs/issues/56943 for now
  ];
  propagatedBuildInputs = with python3.pkgs; [ pygobject3 pycairo ];
  checkInputs = [ xvfb_run python3.pkgs.pytest dbus gtksourceview gtk3 ];

  installPhase = ''
    runHook preInstall
    ${python3.interpreter} setup.py install --prefix=$out
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    # Unable to create user data directory '/homeless-shelter/.local/share' for storing the recently used files list: Permission denied
    mkdir test-home
    export HOME=$(pwd)/test-home

    # GLib.GError: gtk-icon-theme-error-quark: Icon 'meld-change-apply-right' not present in theme Adwaita
    export XDG_DATA_DIRS="$out/share:$XDG_DATA_DIRS"

    # ModuleNotFoundError: No module named 'meld'
    export PYTHONPATH=$out/${python3.sitePackages}:$PYTHONPATH

    # Gtk-CRITICAL **: gtk_icon_theme_get_for_screen: assertion 'GDK_IS_SCREEN (screen)' failed
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      py.test

    runHook postCheck
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Visual diff and merge tool";
    homepage = http://meldmerge.org/;
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jtojnar mimadrid ];
  };
}

{ lib, python3Packages, fetchFromGitHub, gtk3, cairo
, aspellDicts, buildEnv
, gnome3, hicolor_icon_theme
, xvfb_run, dbus, libnotify
}:

python3Packages.buildPythonApplication rec {
  name = "paperwork-${version}";
  # Don't forget to also update paperwork-backend when updating this!
  version = "1.2";

  src = fetchFromGitHub {
    repo = "paperwork";
    owner = "jflesch";
    rev = version;
    sha256 = "1cb9wnhhpm3dyxjrkyl9bbva56xx85vlwlb7z07m1icflcln14x5";
  };

  # Patch out a few paths that assume that we're using the FHS:
  postPatch = ''
    themeDir="$(echo "${gnome3.defaultIconTheme}/share/icons/"*)"
    sed -i -e "s,/usr/share/icons/gnome,$themeDir," src/paperwork/deps.py

    sed -i -e 's,sys\.prefix,"",g' \
      src/paperwork/frontend/aboutdialog/__init__.py \
      src/paperwork/frontend/mainwindow/__init__.py \
      setup.py

    sed -i -e '/^UI_FILES_DIRS = \[/,/^\]$/ {
      c UI_FILES_DIRS = ["'"$out/share/paperwork"'"]
    }' src/paperwork/frontend/util/__init__.py

    sed -i -e '/^LOCALE_PATHS = \[/,/^\]$/ {
      c LOCALE_PATHS = ["'"$out/share"'"]
    }' src/paperwork/paperwork.py

    sed -i -e 's/"icon"/"icon-name"/g' \
      src/paperwork/frontend/mainwindow/mainwindow.glade

    sed -i -e 's/"logo"/"logo-icon-name"/g' \
      src/paperwork/frontend/aboutdialog/aboutdialog.glade
  '';

  ASPELL_CONF = "dict-dir ${buildEnv {
    name = "aspell-all-dicts";
    paths = lib.collect lib.isDerivation aspellDicts;
  }}/lib/aspell";

  checkInputs = [ xvfb_run dbus.daemon ];
  buildInputs = [ gnome3.defaultIconTheme hicolor_icon_theme libnotify ];

  # A few parts of chkdeps need to have a display and a dbus session, so we not
  # only need to run a virtual X server + dbus but also have a large enough
  # resolution, because the Cairo test tries to draw a 200x200 window.
  preCheck = ''
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      paperwork-shell chkdeps paperwork
  '';

  propagatedBuildInputs = with python3Packages; [
    paperwork-backend pypillowfight gtk3 cairo pyxdg dateutil
  ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\""
    "--prefix XDG_DATA_DIRS : \"$out/share\""
    "--suffix XDG_DATA_DIRS : \"$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\""
  ];

  meta = {
    description = "A personal document manager for scanned documents";
    homepage = https://github.com/jflesch/paperwork;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aszlig ];
    platforms = lib.platforms.linux;
  };
}

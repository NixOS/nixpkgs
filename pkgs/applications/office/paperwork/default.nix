{ lib, python3Packages, fetchFromGitLab, gtk3, cairo
, aspellDicts, buildEnv
, gnome3, hicolor-icon-theme, librsvg
, xvfb_run, dbus, libnotify
}:

python3Packages.buildPythonApplication rec {
  inherit (python3Packages.paperwork-backend) version src;
  pname = "paperwork";

  sourceRoot = "source/paperwork-gtk";

  # Patch out a few paths that assume that we're using the FHS:
  postPatch = ''
    themeDir="$(echo "${gnome3.adwaita-icon-theme}/share/icons/"*)"
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

    cat - ../AUTHORS.py > src/paperwork/_version.py <<EOF
    # -*- coding: utf-8 -*-
    version = "${version}"
    authors_code=""
    EOF
  '';

  ASPELL_CONF = "dict-dir ${buildEnv {
    name = "aspell-all-dicts";
    paths = lib.collect lib.isDerivation aspellDicts;
  }}/lib/aspell";

  checkInputs = [ xvfb_run dbus.daemon ] ++ (with python3Packages; [ paperwork-backend ]);
  buildInputs = [
    gnome3.adwaita-icon-theme hicolor-icon-theme libnotify librsvg
  ];

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
    "--set GDK_PIXBUF_MODULE_FILE \"$GDK_PIXBUF_MODULE_FILE\""
    "--prefix XDG_DATA_DIRS : \"$out/share\""
    "--suffix XDG_DATA_DIRS : \"$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\""
  ];

  meta = {
    description = "A personal document manager for scanned documents";
    homepage = https://openpaper.work/;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aszlig ];
    platforms = lib.platforms.linux;
  };
}

{ lib
, python3Packages
, gtk3
, cairo
, gnome3
, librsvg
, xvfb_run
, dbus
, libnotify
, wrapGAppsHook
, fetchFromGitLab
, which
, gettext
, gobject-introspection
}:

python3Packages.buildPythonApplication rec {
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;
  pname = "paperwork";

  sourceRoot = "source/paperwork-gtk";

  # Patch out a few paths that assume that we're using the FHS:
  postPatch = ''
    chmod a+w -R ..
    patchShebangs ../tools

    export HOME=$(mktemp -d)

    cat - ../AUTHORS.py > src/paperwork_gtk/_version.py <<EOF
    # -*- coding: utf-8 -*-
    version = "${version}"
    authors_code=""
    EOF
  '';

  preBuild = ''
    make l10n_compile
  '';

  postInstall = ''
    # paperwork-shell needs to be re-wrapped with access to paperwork
    cp ${python3Packages.paperwork-shell}/bin/.paperwork-cli-wrapped $out/bin/paperwork-cli
    # install desktop files and icons
    XDG_DATA_HOME=$out/share $out/bin/paperwork-gtk install --user

    # fixes [WARNING] [openpaperwork_core.resources.setuptools] Failed to find
    # resource file paperwork_gtk.icon.out/paperwork_128.png, tried at path
    # /nix/store/3n5lz6y8k9yks76f0nar3smc8djan3xr-paperwork-2.0.2/lib/python3.8/site-packages/paperwork_gtk/icon/out/paperwork_128.png.
    site=$out/lib/${python3Packages.python.libPrefix}/site-packages/paperwork_gtk
    for i in $site/data/paperwork_*.png; do
      ln -s $i $site/icon/out;
    done
  '';

  checkInputs = [ xvfb_run dbus.daemon ];

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
    (lib.getBin gettext)
    which
  ];

  buildInputs = [
    gnome3.adwaita-icon-theme
    libnotify
    librsvg
    gtk3
    cairo
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # A few parts of chkdeps need to have a display and a dbus session, so we not
  # only need to run a virtual X server + dbus but also have a large enough
  # resolution, because the Cairo test tries to draw a 200x200 window.
  preCheck = ''
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      $out/bin/paperwork-gtk chkdeps
  '';

  propagatedBuildInputs = with python3Packages; [
    paperwork-backend
    paperwork-shell
    openpaperwork-gtk
    openpaperwork-core
    pypillowfight
    pyxdg
    dateutil
    setuptools
  ];

  meta = {
    description = "A personal document manager for scanned documents";
    homepage = "https://openpaper.work/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aszlig symphorien ];
    platforms = lib.platforms.linux;
  };
}

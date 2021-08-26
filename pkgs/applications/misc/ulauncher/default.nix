{ lib
, fetchurl
, nix-update-script
, python3Packages
, gdk-pixbuf
, glib
, gnome
, gobject-introspection
, gtk3
, wrapGAppsHook
, webkitgtk
, libnotify
, keybinder3
, libappindicator
, intltool
, wmctrl
, xvfb-run
, librsvg
}:

python3Packages.buildPythonApplication rec {
  pname = "ulauncher";
  version = "5.11.0";

  disabled = python3Packages.isPy27;

  src = fetchurl {
    url = "https://github.com/Ulauncher/Ulauncher/releases/download/${version}/ulauncher_${version}.tar.gz";
    sha256 = "sha256-xEM7sG0NRWouDu6NxNA94WTycykEhPI4ByjDk2yjHjo=";
  };

  nativeBuildInputs = with python3Packages; [
    distutils_extra
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gnome.adwaita-icon-theme
    gobject-introspection
    gtk3
    keybinder3
    libappindicator
    libnotify
    librsvg
    webkitgtk
    wmctrl
  ];

  propagatedBuildInputs = with python3Packages; [
    mock
    mypy
    mypy-extensions
    dbus-python
    pygobject3
    pyinotify
    python-Levenshtein
    pyxdg
    requests
    websocket-client
  ];

  checkInputs = with python3Packages; [
    mock
    pytest
    pytest-mock
    xvfb-run
  ];

  patches = [
    ./fix-path.patch
    ./0001-Adjust-get_data_path-for-NixOS.patch
    ./fix-extensions.patch
  ];

  postPatch = ''
    substituteInPlace setup.py --subst-var out
  '';

  # https://github.com/Ulauncher/Ulauncher/issues/390
  doCheck = false;

  preCheck = ''
    export PYTHONPATH=$PYTHONPATH:$out/${python3Packages.python.sitePackages}
  '';

  # Simple translation of
  # - https://github.com/Ulauncher/Ulauncher/blob/f5a601bdca75198a6a31b9d84433496b63530e74/test
  checkPhase = ''
    runHook preCheck

    # skip tests in invocation that handle paths that
    # aren't nix friendly (i think)
    xvfb-run -s '-screen 0 1024x768x16' \
      pytest -k 'not TestPath and not test_handle_key_press_event' tests

    runHook postCheck
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ wmctrl ]}")
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };


  meta = with lib; {
    description = "A fast application launcher for Linux, written in Python, using GTK";
    homepage = "https://ulauncher.io/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aaronjanse ];
  };
}

{ stdenv
, fetchurl
, python27Packages
, gnome3
, gobject-introspection
, wrapGAppsHook
, webkitgtk
, libnotify
, keybinder3
, libappindicator
, intltool
, wmctrl
, xvfb_run
}:

python27Packages.buildPythonApplication rec  {
  pname = "ulauncher";
  version = "4.4.0.r1";

  # Python 3 support is currently in development
  # on the dev branch and 5.x.x releases
  disabled = ! python27Packages.isPy27;

  src = fetchurl {
    url = "https://github.com/Ulauncher/Ulauncher/releases/download/${version}/ulauncher_${version}.tar.gz";
    sha256 = "12v7qpjhf0842ivsfflsl2zlvhiaw25f9ffv7vhnkvrhrmksim9f";
  };

  nativeBuildInputs = with python27Packages;  [
    distutils_extra
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.adwaita-icon-theme
    gobject-introspection
    keybinder3
    libappindicator
    libnotify
    webkitgtk
    wmctrl
  ];

  propagatedBuildInputs = with python27Packages; [
    dbus-python
    notify
    pygobject3
    pyinotify
    pysqlite
    python-Levenshtein
    pyxdg
    websocket_client
  ];

  checkInputs = with python27Packages; [
    mock
    pytest
    pytest-mock
    pytestpep8
    xvfb_run
  ];

  patches = [
    ./fix-path.patch
  ];

  postPatch = ''
    substituteInPlace setup.py --subst-var out
  '';

  # https://github.com/Ulauncher/Ulauncher/issues/390
  doCheck = false;

  preCheck = ''
    export PYTHONPATH=$PYTHONPATH:$out/${python27Packages.python.sitePackages}
  '';

  # Simple translation of
  # - https://github.com/Ulauncher/Ulauncher/blob/f5a601bdca75198a6a31b9d84433496b63530e74/test
  checkPhase = ''
    runHook preCheck

    # skip tests in invocation that handle paths that
    # aren't nix friendly (i think)
    xvfb-run -s '-screen 0 1024x768x16' \
      pytest -k 'not TestPath and not test_handle_key_press_event' --pep8 tests

    runHook postCheck
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${stdenv.lib.makeBinPath [ wmctrl ]}")
  '';

  meta = with stdenv.lib; {
    description = "A fast application launcher for Linux, written in Python, using GTK";
    homepage = https://ulauncher.io/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aaronjanse worldofpeace ];
  };
}

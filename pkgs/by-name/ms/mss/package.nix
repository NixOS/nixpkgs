{ lib
, fetchFromGitHub
, hdf4
, libtiff
, python3
, qt5
}:

python3.pkgs.buildPythonApplication rec {
  pname = "MSS";
  version = "9.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Open-MSS";
    repo = "MSS";
    rev = version;
    hash = "sha256-3TMnEvjxv5B0/1LYsLe/QcEtJSGeOeHMxRnGLz/QKY0=";
  };

  patches = [
    ./fix-git-repo-error.patch
  ];

  nativeBuildInputs = with python3.pkgs; [
    future
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    basemap
    cftime
    chameleon
    dbus-python
    defusedxml
    email-validator
    execnet
    fastkml
    flask
    flask-cors
    flask-httpauth
    flask-login
    flask-mail
    flask-migrate
    flask-socketio
    flask-sqlalchemy
    flask-wtf
    fs
    fs_filepicker
    gitpython
    gpxpy
    hdf4
    isodate
    itsdangerous
    keyring
    libtiff
    lxml
    markdown
    matplotlib
    metpy
    multidict
    netcdf4
    owslib
    passlib
    pillow
    pint
    psycopg2
    pycountry
    pyjwt
    pymysql
    pyqt5
    pysaml2
    python-engineio
    python-slugify
    python-socketio
    requests
    scipy
    shapely
    skyfield
    skyfield-data
    sqlalchemy
    tkinter
    unicodecsv
    validate-email
    websocket-client
    werkzeug
    xmlsec
    xstatic
    xstatic-bootstrap
    xstatic-jquery
  ];

  nativeCheckInputs = with python3.pkgs; [
    eventlet
    mock
    pynco
    pytest-qt
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
    export QT_QPA_PLATFORM=offscreen
  '';

  # Both test_milestone_url and test_download_progress require network access
  disabledTests = [
    "test_download_progress"
    "test_milestone_url"
  ];

  # The tests in these files are flaky (they also make problems upstream)
  disabledTestFiles = [
    "tests/_test_msui/test_sideview.py"
    "tests/_test_msui/test_topview.py"
    "tests/_test_msui/test_wms_control.py"
  ];

  # Properly wrap the pyqt application
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/msui"
  '';

  meta = with lib; {
    description = "QT application, OGC web map server, collaboration server to plan atmospheric research flights";
    homepage = "https://github.com/Open-MSS/MSS";
    license = licenses.asl20;
    maintainers = with maintainers; [ matrss ];
  };
}

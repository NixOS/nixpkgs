{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  python3Packages,
  qt6Packages,
  libvncserver,
}:

python3Packages.buildPythonApplication rec {
  pname = "blink-qt";
  version = "6.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "blink-qt";
    tag = version;
    hash = "sha256-QESg9yo5oddYqSKuFLSMI2Oju3FCq97+j0uJDK85Yy8=";
  };

  patches = [
    # Remove when version > 6.0.4
    (fetchpatch2 {
      url = "https://github.com/AGProjects/blink-qt/commit/45343c90ae0680a3d03589fa8a12ac1eb85a6925.patch";
      hash = "sha256-XwV5L3r0IqWkhlaJypS2cHkDCcoumOgEEqDpdcaTviE=";
    })
  ];

  nativeBuildInputs = [ qt6Packages.wrapQtAppsHook ];

  build-system = with python3Packages; [
    cython
    setuptools
  ];

  buildInputs = [
    libvncserver
    qt6Packages.qtbase
    qt6Packages.qtsvg
  ];

  dependencies = with python3Packages; [
    dateutils
    dnspython
    google-api-python-client
    lxml
    lxml-html-clean
    msrplib
    oauth2client
    otr
    pgpy
    pyqt6
    pyqt6-webengine
    python3-application
    python3-eventlib
    python3-gnutls
    sipsimple
    sqlobject
    standard-imghdr
    xcaplib
  ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  pythonImportsCheck = [ "blink" ];

  # no upstream tests exist
  doCheck = false;

  meta = {
    description = "Blink SIP Client";
    homepage = "https://icanblink.com";
    downloadPage = "https://github.com/agprojects/blink-qt";
    changelog = "https://github.com/AGProjects/blink-qt/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.unix;
    mainProgram = "blink";
  };
}

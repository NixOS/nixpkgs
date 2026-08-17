{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  python3Packages,
  qt6Packages,
  libvncserver,
  stdenv,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "blink-qt";
  version = "6.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "blink-qt";
    tag = finalAttrs.version;
    hash = "sha256-0hsuAYYp7KvfxErAcN4EX8G3goirGRmpijJfAMvbZJQ=";
  };

  patches = [
    # Remove once https://github.com/AGProjects/blink-qt/pull/7 is mereged and tagged
    ./fix-none-account.patch
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

  dependencies =
    with python3Packages;
    [
      dateutils
      dnspython
      google-auth-oauthlib
      google-api-python-client
      lxml
      lxml-html-clean
      msrplib
      otr
      pgpy
      pyqt6
      pyqt6-webengine
      python3-application
      python3-eventlib
      python3-gnutls
      python3-sipsimple
      sqlobject
      standard-imghdr
      xcaplib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      numpy
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
    changelog = "https://github.com/AGProjects/blink-qt/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.unix;
    mainProgram = "blink";
  };
})

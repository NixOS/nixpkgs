{
  lib,
  cacert,
  fetchFromGitHub,
  python3Packages,
  qt6Packages,
  libvncserver,
  stdenv,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "blink-qt";
  version = "7.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "blink-qt";
    tag = finalAttrs.version;
    hash = "sha256-cFfPSTCHhaZbf1Dy9nvWHd69P/pfZBjIKV1PcOSmQy4=";
  };

  nativeBuildInputs = [ qt6Packages.wrapQtAppsHook ];

  build-system = with python3Packages; [
    cython_3_2
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
      python3-otr
      pgpy
      pyqt6
      pyqt6-webengine
      python3-application
      python3-eventlib
      python3-gnutls
      python3-msrplib
      python3-sipsimple
      python3-xcaplib
      sqlobject
      standard-imghdr
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      numpy
    ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postFixup = ''
    rm $out/share/blink/tls/ca.crt
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/share/blink/tls/ca.crt
  '';

  pythonImportsCheck = [ "blink" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'blink.conference'
    "tests/test_pstn_normalize.py::ConferenceTests::test_conference_domains"

    # AssertionError: Tuples differ: ('✓✓', 'displayed') != ('✔✔', 'displayed')
    "tests/test_messagepane_format.py::DayTests::test_marks"

    # FileNotFoundError: [Errno 2] No such file or directory:
    # '/nix/store/<hash>-python3.14-pytest-9.1.1/lib/python3.14/site-packages/pytest/share/blink/session_info_panel.ui'
    "tests/test_contact_repair.py::NameTests::test_echoed_names"
    "tests/test_contact_repair.py::PlanTests::test_full_plan"
  ];

  meta = {
    description = "Blink SIP Client";
    homepage = "https://icanblink.com";
    downloadPage = "https://github.com/agprojects/blink-qt";
    changelog = "https://github.com/AGProjects/blink-qt/blob/${finalAttrs.src.rev}/debian/changelog";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.unix;
    mainProgram = "blink";
  };
})

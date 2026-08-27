{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nagstamon";
  version = "3.18.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HenriWahl";
    repo = "Nagstamon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZA6gxV9zLKZ0g5v8CvnAuiYPhEDByz17kC54Idk9CYM=";
  };

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [ qt6Packages.wrapQtAppsHook ];

  buildInputs = [
    qt6Packages.qtmultimedia
    qt6Packages.qtsvg
  ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  dependencies = with python3Packages; [
    arrow
    beautifulsoup4
    configparser
    dbus-python
    keyring
    lxml
    packaging
    psutil
    pyqt6
    pyqt6-webengine
    pysocks
    python-dateutil
    requests
    requests-kerberos
    setuptools
    tzlocal
  ];

  nativeCheckInputs = with python3Packages; [
    pylint
    pytestCheckHook
  ];

  meta = {
    description = "Status monitor for the desktop";
    homepage = "https://nagstamon.de/";
    changelog = "https://github.com/HenriWahl/Nagstamon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pSub
      liberodark
      videl
    ];
    mainProgram = "nagstamon.py";
    # NameError: name 'bdist_rpm_options' is not defined. Did you mean: 'bdist_mac_options'?
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
  };
})

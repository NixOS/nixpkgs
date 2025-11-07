{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "nagstamon";
  version = "3.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HenriWahl";
    repo = "Nagstamon";
    tag = "v${version}";
    hash = "sha256-9w8ux+AeSg0vDhnk28/2eCE2zYLvAjD7mB0pJBMFs2I=";
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
    psutil
    pyqt6
    pysocks
    python-dateutil
    requests
    requests-kerberos
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pylint
    pytestCheckHook
  ];

  meta = {
    description = "Status monitor for the desktop";
    homepage = "https://nagstamon.de/";
    changelog = "https://github.com/HenriWahl/Nagstamon/releases/tag/v${version}";
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
}

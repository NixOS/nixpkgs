{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt6,
}:

python3Packages.buildPythonApplication rec {
  pname = "meteo-qt";
  version = "4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dglent";
    repo = "meteo-qt";
    tag = "v${version}";
    hash = "sha256-s02A5WwJffjbB497sXyugkIolqyK3OpEY7aBgnOBdbM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "lrelease-pro-qt6" "${qt6.qttools}/libexec/lrelease-pro"
  '';

  nativeBuildInputs = [
    qt6.qttools
    qt6.wrapQtAppsHook
    python3Packages.pyqt6
  ];

  build-system = with python3Packages; [
    setuptools
    sip
  ];

  dependencies = with python3Packages; [
    lxml
    pyqt6
  ];

  postFixup = ''
    mv $out/${python3Packages.python.sitePackages}/usr/share $out/share
  '';

  pythonImportsCheck = [ "meteo_qt" ];

  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  meta = {
    description = "System tray application for weather status information";
    homepage = "https://github.com/dglent/meteo-qt";
    changelog = "https://github.com/dglent/meteo-qt/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linuxissuper ];
    mainProgram = "meteo-qt";
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt5,
}:

python3Packages.buildPythonApplication rec {
  pname = "meteo-qt";
  version = "3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dglent";
    repo = "meteo-qt";
    rev = "refs/tags/v${version}";
    hash = "sha256-J9R6UGfj3vaPfn0vmjeRMsHryc/1pxoKyIE9wteVYbY=";
  };

  nativeBuildInputs = [
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  build-system = with python3Packages; [ sip ];

  dependencies = with python3Packages; [
    lxml
    pyqt5
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

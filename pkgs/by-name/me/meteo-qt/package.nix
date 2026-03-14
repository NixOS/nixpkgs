{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt6,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "meteo-qt";
  version = "4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dglent";
    repo = "meteo-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ksG5cnVV/4QOCzK+UWwe7LjPncIeFElAuTK60KaHgrY=";
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
    changelog = "https://github.com/dglent/meteo-qt/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linuxissuper ];
    mainProgram = "meteo-qt";
    platforms = lib.platforms.linux;
  };
})

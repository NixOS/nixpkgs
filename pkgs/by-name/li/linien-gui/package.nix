{
  lib,
  python3,
  qt5,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "linien-gui";
  pyproject = true;

  inherit (python3.pkgs.linien-common) src version;

  sourceRoot = "${src.name}/linien-gui";

  nativeBuildInputs =
    with python3.pkgs;
    [
      setuptools
    ]
    ++ [
      qt5.wrapQtAppsHook
    ];

  # Makes qt-wayland appear in the qt paths injected by the wrapper - helps users
  # with `QT_QPA_PLATFORM=wayland` in their environment.
  buildInputs = [
    qt5.qtwayland
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    click
    pyqtgraph
    pyqt5
    superqt
    linien-client
    requests
  ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Graphical user interface of the Linien spectroscopy lock application";
    mainProgram = "linien";
    homepage = "https://github.com/linien-org/linien/tree/develop/linien-gui";
    changelog = "https://github.com/linien-org/linien/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      fsagbuya
      doronbehar
    ];
  };
}

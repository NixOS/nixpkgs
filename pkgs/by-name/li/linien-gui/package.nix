{
  lib,
  python3,
  qt5,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      numpy = super.numpy_1;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "linien-gui";
  pyproject = true;

  inherit (python.pkgs.linien-common) src version;

  sourceRoot = "${src.name}/linien-gui";

  build-system = with python.pkgs; [
    setuptools
  ];
  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  # Makes qt-wayland appear in the qt paths injected by the wrapper - helps users
  # with `QT_QPA_PLATFORM=wayland` in their environment.
  buildInputs = [
    qt5.qtwayland
  ];

  dependencies = with python.pkgs; [
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

  passthru = {
    # Useful for creating .withPackages environments, see NOTE near
    # `python3Packages.linien-common.meta.broken`.
    inherit python;
  };

  meta = {
    description = "Graphical user interface of the Linien spectroscopy lock application";
    mainProgram = "linien";
    homepage = "https://github.com/linien-org/linien/tree/develop/linien-gui";
    changelog = "https://github.com/linien-org/linien/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      fsagbuya
      doronbehar
    ];
  };
}

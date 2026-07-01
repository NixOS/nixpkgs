{
  lib,
  fetchFromGitHub,
  libsForQt5,
  makeDesktopItem,
  nix-update-script,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cq-editor";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "cq-editor";
    rev = finalAttrs.version;
    hash = "sha256-8Kj8WmzlchDbd7H9MJatUHsevJf1NSQjshor+vrdhwg=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [ libsForQt5.wrapQtAppsHook ];

  dependencies = [
    python3Packages.cadquery
    python3Packages.logbook
    python3Packages.path
    python3Packages.pyqt5
    python3Packages.pyqtgraph
    python3Packages.qtawesome
    python3Packages.qtconsole
    python3Packages.requests
  ];

  pythonRelaxDeps = [
    "qtawesome"
    "qtconsole"
  ];

  # cq-editor crashes when trying to use Wayland, so force xcb:
  # https://github.com/CadQuery/CQ-editor/issues/266
  qtWrapperArgs = [ "--set QT_QPA_PLATFORM xcb" ];

  postFixup = ''
    wrapQtApp "$out/bin/cq-editor"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.cadquery.CadQuery";
      desktopName = "CadQuery";
      icon = "cadquery";
      exec = "cq-editor %f";
      categories = [
        "Graphics"
        "3DGraphics"
        "Engineering"
      ];
      type = "Application";
      comment = "CadQuery GUI editor based on PyQT";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CadQuery GUI editor based on PyQT";
    homepage = "https://github.com/CadQuery/CQ-editor";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})

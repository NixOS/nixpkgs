{
  fetchFromGitHub,
  gns3-gui,
  lib,
  python3Packages,
  qt5,
  testers,
  writableTmpDirAsHomeHook,
}:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      pyqt5 = prev.pyqt5.override { withWebSockets = true; };
    }
  );
in
pythonPackages.buildPythonApplication rec {
  pname = "gns3-gui";
  version = "2.2.55";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "gns3-gui";
    tag = "v${version}";
    hash = "sha256-6jblQakNpoSQXfy5pU68Aedg661VcwpqQilvqOV15pQ";
  };

  pythonRelaxDeps = [
    "jsonschema"
    "sentry-sdk"
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  buildInputs = [ qt5.qtwayland ];

  build-system = with pythonPackages; [ setuptools ];

  dependencies = with pythonPackages; [
    distro
    jsonschema
    psutil
    pyqt5
    sentry-sdk
    setuptools
    sip
    truststore
  ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  nativeCheckInputs = with pythonPackages; [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export QT_PLUGIN_PATH="${lib.getBin qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${lib.getBin qt5.qtbase}/lib/qt-${qt5.qtbase.version}/plugins";
    export QT_QPA_PLATFORM=offscreen
  '';

  passthru.tests.version = testers.testVersion {
    package = gns3-gui;
    command = "${lib.getExe gns3-gui} --version";
  };

  meta = {
    description = "Graphical Network Simulator 3 GUI";
    longDescription = ''
      Graphical user interface for controlling the GNS3 network simulator. This
      requires access to a local or remote GNS3 server (it's recommended to
      download the official GNS3 VM).
    '';
    homepage = "https://www.gns3.com/";
    changelog = "https://github.com/GNS3/gns3-gui/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    mainProgram = "gns3";
  };
}

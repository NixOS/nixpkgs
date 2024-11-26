{
  channel,
  version,
  hash,
}:

{
  fetchFromGitHub,
  gns3-gui,
  lib,
  python3Packages,
  qt5,
  testers,
  wrapQtAppsHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "gns3-gui";
  inherit version;

  src = fetchFromGitHub {
    inherit hash;
    owner = "GNS3";
    repo = "gns3-gui";
    rev = "refs/tags/v${version}";
  };

  nativeBuildInputs = with python3Packages; [ wrapQtAppsHook ];

  build-system = with python3Packages; [ setuptools ];

  propagatedBuildInputs = [ qt5.qtwayland ];

  dependencies =
    with python3Packages;
    [
      distro
      jsonschema
      psutil
      sentry-sdk
      setuptools
      sip
      (pyqt5.override { withWebSockets = true; })
      truststore
    ]
    ++ lib.optionals (pythonOlder "3.9") [
      importlib-resources
    ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/gns3"
  '';

  doCheck = true;

  checkInputs = with python3Packages; [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
    export QT_QPA_PLATFORM=offscreen
  '';

  passthru.tests.version = testers.testVersion {
    package = gns3-gui;
    command = "${lib.getExe gns3-gui} --version";
  };

  meta = {
    description = "Graphical Network Simulator 3 GUI (${channel} release)";
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

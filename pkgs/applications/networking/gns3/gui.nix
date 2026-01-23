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

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      pyqt5 = prev.pyqt5.override { withWebSockets = true; };
    }
  );
in
pythonPackages.buildPythonApplication rec {
  pname = "gns3-gui";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    inherit hash;
    owner = "GNS3";
    repo = "gns3-gui";
    tag = "v${version}";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  build-system = with pythonPackages; [ setuptools ];

  propagatedBuildInputs = [ qt5.qtwayland ];

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
    wrapQtApp "$out/bin/gns3"
  '';

  doCheck = true;

  checkInputs = with pythonPackages; [ pytestCheckHook ];

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

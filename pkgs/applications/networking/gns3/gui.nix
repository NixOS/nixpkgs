{ channel
, version
, hash
}:

{ lib
, python3
, fetchFromGitHub
, qt5
, wrapQtAppsHook
, testers
, gns3-gui
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gns3-gui";
  inherit version;

  src = fetchFromGitHub {
    inherit hash;
    owner = "GNS3";
    repo = pname;
    rev = "refs/tags/v${version}";
  };

  nativeBuildInputs = with python3.pkgs; [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jsonschema
    psutil
    sentry-sdk
    setuptools
    sip
    (pyqt5.override { withWebSockets = true; })
    truststore
    qt5.qtwayland
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/gns3"
  '';

  doCheck = true;

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

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

  meta = with lib; {
    description = "Graphical Network Simulator 3 GUI (${channel} release)";
    longDescription = ''
      Graphical user interface for controlling the GNS3 network simulator. This
      requires access to a local or remote GNS3 server (it's recommended to
      download the official GNS3 VM).
    '';
    homepage = "https://www.gns3.com/";
    changelog = "https://github.com/GNS3/gns3-gui/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ anthonyroussel ];
    mainProgram = "gns3";
  };
}

{
  fetchFromGitHub,
  fetchpatch,
  gns3-gui,
  gns3-server,
  lib,
  python3Packages,
  qt6,
  testers,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gns3-gui";
  version = "2.2.56.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "gns3-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HBTBwn7jAW/SXFTfPbO08bDG5NfS3tuic/Z0ib1/Uo8=";
  };

  patches = [
    # Fix tests after PyQt6 migration
    (fetchpatch {
      url = "https://github.com/GNS3/gns3-gui/commit/e6e2a1cafbc3ce4be9cca3428e60400f25806cde.patch";
      hash = "sha256-T15OCqm+Te9ZOCg/kFf/fd2DY75LfaLHskAAgGYMloI=";
    })
  ];

  pythonRelaxDeps = [
    "jsonschema"
    "psutil"
    "sentry-sdk"
  ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [ qt6.qtwayland ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    distro
    jsonschema
    psutil
    pyqt6
    sentry-sdk
    setuptools
    sip
    truststore
  ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export QT_PLUGIN_PATH="${lib.getBin qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = gns3-gui;
      command = "${lib.getExe gns3-gui} --version";
    };
    inherit (gns3-server.passthru) updateScript;
  };

  meta = {
    description = "Graphical Network Simulator 3 GUI";
    longDescription = ''
      Graphical user interface for controlling the GNS3 network simulator. This
      requires access to a local or remote GNS3 server (it's recommended to
      download the official GNS3 VM).
    '';
    homepage = "https://www.gns3.com/";
    changelog = "https://github.com/GNS3/gns3-gui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    mainProgram = "gns3";
  };
})

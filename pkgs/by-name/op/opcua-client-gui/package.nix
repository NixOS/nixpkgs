{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
  qt6,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "opcua-client-gui";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-client-gui";
    tag = finalAttrs.version;
    hash = "sha256-4GjKfcWktbPV6JAO7My95GiYVXGl6QnwVomkwKXuHGo=";
  };

  build-system = with python3Packages; [ setuptools ];

  buildInputs = [
    qt6.qtwayland
  ];

  nativeBuildInputs = [
    copyDesktopItems
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  dependencies = with python3Packages; [
    pyqt6
    asyncua
    numpy
    pyqtgraph
  ];

  pythonImportsCheck = [
    "uaclient"
    "uawidgets"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "opcua-client";
      exec = "opcua-client";
      comment = "OPC UA Client";
      # No icon because the app doesn't have one.
      desktopName = "opcua-client";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "OPC UA GUI Client";
    homepage = "https://github.com/FreeOpcUa/opcua-client-gui";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "opcua-client";
  };
})

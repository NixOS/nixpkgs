{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapQtAppsHook,
  borgbackup,
  qtbase,
  qtwayland,
  stdenv,
  makeFontsConf,
}:

python3Packages.buildPythonApplication rec {
  pname = "vorta";
  version = "0.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vorta";
    tag = "v${version}";
    hash = "sha256-VhM782mFWITA0VlKw0sBIu/UxUqlFLgq5XVdCpQggCw=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    wrapQtAppsHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
  ];

  propagatedBuildInputs = with python3Packages; [
    peewee
    pyqt6
    psutil
    secretstorage
    setuptools
    platformdirs
  ];

  postPatch = ''
    substituteInPlace src/vorta/assets/metadata/com.borgbase.Vorta.desktop \
    --replace com.borgbase.Vorta "com.borgbase.Vorta-symbolic"
  '';

  postInstall = ''
    install -Dm644 src/vorta/assets/metadata/com.borgbase.Vorta.desktop $out/share/applications/com.borgbase.Vorta.desktop
    install -Dm644 src/vorta/assets/icons/icon.svg $out/share/pixmaps/com.borgbase.Vorta-symbolic.svg
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ borgbackup ]}
    )
  '';

  nativeCheckInputs = with python3Packages; [
    pytest-qt
    pytest-mock
    pytestCheckHook
  ];

  preCheck =
    let
      fontsConf = makeFontsConf {
        fontDirectories = [ ];
      };
    in
    ''
      export HOME=$(mktemp -d)
      export FONTCONFIG_FILE=${fontsConf};
      # For tests/test_misc.py::test_autostart
      mkdir -p $HOME/.config/autostart
      export QT_PLUGIN_PATH="${qtbase}/${qtbase.qtPluginPrefix}"
      export QT_QPA_PLATFORM=offscreen
    '';

  disabledTestPaths =
    [
      # QObject::connect: No such signal QPlatformNativeInterface::systemTrayWindowChanged(QScreen*)    "tests/test_excludes.py"
      "tests/integration"
      "tests/unit"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # Darwin-only test
      "tests/network_manager/test_darwin.py"
    ];

  meta = with lib; {
    changelog = "https://github.com/borgbase/vorta/releases/tag/v${version}";
    description = "Desktop Backup Client for Borg";
    homepage = "https://vorta.borgbase.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
    mainProgram = "vorta";
  };
}

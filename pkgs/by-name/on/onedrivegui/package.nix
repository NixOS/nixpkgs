{
  lib,
  python3Packages,
  qt6,
  fetchFromGitHub,
  writeText,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  onedrive,
}:

let
  version = "1.2.1";

  setupPy = writeText "setup.py" ''
    from setuptools import setup
    setup(
      name='onedrivegui',
      version='${version}',
      scripts=[
        'src/OneDriveGUI.py',
      ],
    )
  '';

in
python3Packages.buildPythonApplication rec {
  pname = "onedrivegui";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bpozdena";
    repo = "OneDriveGUI";
    tag = "v${version}";
    hash = "sha256-QCSCJ1m/PKSpkfseq8fyDEHFyIt156Lp15JC04NY0ps=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    copyDesktopItems
    qt6.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  dependencies = with python3Packages; [
    pyside6
    requests
  ];

  # wrap manually to avoid having a bash script in $out/bin with a .py extension
  dontWrapPythonPrograms = true;
  dontWrapQtApps = true;

  doCheck = false; # No tests defined
  # pythonImportsCheck = [ "OneDriveGUI" ]; # requires a display

  desktopItems = [
    (makeDesktopItem {
      name = "OneDriveGUI";
      exec = "onedrivegui";
      desktopName = "OneDriveGUI";
      comment = "OneDrive GUI Client";
      type = "Application";
      icon = "OneDriveGUI";
      terminal = false;
      categories = [ "Utility" ];
    })
  ];

  postPatch = ''
    # Patch global_config.py so DIR_PATH points to shared files location
    sed -i src/global_config.py -e "s@^DIR_PATH =.*@DIR_PATH = '$out/share/OneDriveGUI'@"
    cp ${setupPy} ${setupPy.name}
  '';

  postInstall = ''
    mkdir -p $out/share/OneDriveGUI
    # we do not need the `ui` directory - only resources
    cp -r src/resources $out/share/OneDriveGUI
    install -Dm444 -t $/out/share/icons/hicolor/48x48/apps src/resources/images/OneDriveGUI.png
    # we put our own executable wrapper in place instead
    rm -r $out/bin/*

    makeWrapper ${python3Packages.python.interpreter} $out/bin/onedrivegui \
      ''${qtWrapperArgs[@]} \
      --prefix PATH : ${lib.makeBinPath [ onedrive ]} \
      --prefix PYTHONPATH : ${
        python3Packages.makePythonPath (dependencies ++ [ (placeholder "out") ])
      } \
      --add-flags $out/${python3Packages.python.sitePackages}/OneDriveGUI.py
  '';

  meta = {
    homepage = "https://github.com/bpozdena/OneDriveGUI";
    description = "Simple GUI for Linux OneDrive Client, with multi-account support";
    mainProgram = "onedrivegui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}

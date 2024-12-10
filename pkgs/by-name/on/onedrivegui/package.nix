{
  lib,
  python3Packages,
  fetchFromGitHub,
  writeText,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  onedrive,
}:

let
  version = "1.0.3";

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

  src = fetchFromGitHub {
    owner = "bpozdena";
    repo = "OneDriveGUI";
    rev = "v${version}";
    hash = "sha256-HutziAzhIDYP8upNPieL2GNrxPBHUCVs09FFxdSqeBs=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  propagatedBuildInputs = with python3Packages; [
    pyside6
    requests
  ];

  # wrap manually to avoid having a bash script in $out/bin with a .py extension
  dontWrapPythonPrograms = true;

  doCheck = false; # No tests defined
  pythonImportsCheck = [ "OneDriveGUI" ];

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
    # Patch OneDriveGUI.py so DIR_PATH points to shared files location
    sed -i src/OneDriveGUI.py -e "s@^DIR_PATH =.*@DIR_PATH = '$out/share/OneDriveGUI'@"
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
      --prefix PATH : ${lib.makeBinPath [ onedrive ]} \
      --prefix PYTHONPATH : ${
        python3Packages.makePythonPath (propagatedBuildInputs ++ [ (placeholder "out") ])
      } \
      --add-flags $out/${python3Packages.python.sitePackages}/OneDriveGUI.py
  '';

  meta = with lib; {
    homepage = "https://github.com/bpozdena/OneDriveGUI";
    description = "A simple GUI for Linux OneDrive Client, with multi-account support";
    mainProgram = "onedrivegui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.linux;
  };
}

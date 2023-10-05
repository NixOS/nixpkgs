{ lib
, python3Packages
, fetchFromGitHub
, copyDesktopItems
, onedrive
, makeDesktopItem
}:

python3Packages.buildPythonApplication rec {
  pname = "onedrivegui";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "bpozdena";
    repo = "OneDriveGUI";
    rev = "v${version}";
    hash = "sha256-HutziAzhIDYP8upNPieL2GNrxPBHUCVs09FFxdSqeBs=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  propagatedBuildInputs = [ onedrive ] ++
  builtins.attrValues { inherit (python3Packages) pyside6 requests; };

  doCheck = false; # No tests defined

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

  preBuild = ''
    cat > setup.py << EOF
    from setuptools import setup
    setup(
      name='onedrivegui',
      version='$version',
      scripts=[
        'src/OneDriveGUI.py',
      ],
    )
    EOF
  '';

  postInstall = ''
    ln -s $src/src/{resources,ui} $out/bin/
    install -Dm644 src/resources/images/OneDriveGUI.png "$out/share/icons/hicolor/48x48/apps/OneDriveGUI.png"
    mv -v $out/bin/OneDriveGUI.py $out/bin/onedrivegui
  '';

  meta = with lib; {
    homepage = "https://github.com/bpozdena/OneDriveGUI";
    description = "A simple GUI for Linux OneDrive Client, with multi-account support";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jgarcia ];
    platforms = platforms.linux;
  };
}

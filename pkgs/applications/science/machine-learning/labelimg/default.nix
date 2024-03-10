{ lib, python3Packages, fetchFromGitHub, qt5 }:
  python3Packages.buildPythonApplication rec {
    pname = "labelImg";
    version = "1.8.3";
    src = fetchFromGitHub {
      owner = "tzutalin";
      repo = "labelImg";
      rev = "v${version}";
      sha256 = "07v106fzlmxrbag4xm06m4mx9m0gckb27vpwsn7sap1bbgc1pap5";
    };
    nativeBuildInputs = with python3Packages; [
      pyqt5
      qt5.wrapQtAppsHook
    ];
    propagatedBuildInputs = with python3Packages; [
      pyqt5
      lxml
      sip4
    ];
    preBuild = ''
      make qt5py3
    '';
    postInstall = ''
      cp libs/resources.py $out/${python3Packages.python.sitePackages}/libs
    '';
    dontWrapQtApps = true;
    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
    meta = with lib; {
      description = "A graphical image annotation tool and label object bounding boxes in images";
      homepage = "https://github.com/tzutalin/labelImg";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.cmcdragonkai ];
    };
  }

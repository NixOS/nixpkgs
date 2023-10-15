{ lib
, unrar
, python3
, fetchgit
, poetry
, git
, rar
, qt5
, python3Packages
}:

python3.pkgs.buildPythonApplication rec {
  pname = "comictagger";
  version = "1.5.5";
  format = "pyproject";

  src = fetchgit {
    url = "https://github.com/comictagger/comictagger.git";
    rev = "refs/tags/1.5.5";
    sha256 = "sha256-w9YwscJffXJMLCiGUVRC92S2gS1yJPFr+0ttIEW02mc=";
    leaveDotGit = "true";
  };

  propagatedBuildInputs = [

    python3.pkgs.appdirs
    python3.pkgs.beautifulsoup4
    python3.pkgs.importlib-metadata
    python3.pkgs.configparser
    python3.pkgs.natsort
    python3.pkgs.pathvalidate
    python3.pkgs.rarfile
    python3.pkgs.zipfile2
    python3.pkgs.py7zr
    python3.pkgs.pyicu
    python3.pkgs.pillow
    python3.pkgs.pycountry
    python3.pkgs.rapidfuzz
    python3.pkgs.pyinstaller
    python3.pkgs.pypdf2
    python3.pkgs.pyqt5
    python3.pkgs.pyrate-limiter
    python3.pkgs.requests
    python3.pkgs.settngs
    python3.pkgs.setuptools
    python3.pkgs.text2digits
    python3.pkgs.typing-extensions
    python3.pkgs.wordninja
    python3.pkgs.unrar-cffi
    python3.pkgs.xcffib
    qt5.qtwayland
  ];
  nativeBuildInputs = [ git
    qt5.wrapQtAppsHook
                      ];
  buildInputs = [
    qt5.qtbase

  ];
  meta = with lib; {
    description = "A multi-platform app for writing metadata to digital comics";
    homepage = "https://github.com/comictagger/comictagger";
    license = licenses.asl20;
    maintainers =  [ maintainers.provenzano ];
    platforms = [ "x86_64-linux" ];
  };

}

{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "raiseorlaunch";
  version = "2.3.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "3d694015d020a888b42564d56559213b94981ca2b32b952a49b2de4d029d2e59";
  };

  nativeBuildInputs = [ python3Packages.setuptools_scm ];
  checkInputs = [ python3Packages.pytest ];
  pythonPath = with python3Packages; [ i3ipc ];

  meta = with lib; {
    maintainers = with maintainers; [ winpat ];
    description = "A run-or-raise-application-launcher for i3 window manager";
    homepage = "https://github.com/open-dynaMIX/raiseorlaunch";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

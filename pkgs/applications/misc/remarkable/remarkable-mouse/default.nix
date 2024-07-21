{ lib, buildPythonApplication, fetchPypi, python3Packages }:

buildPythonApplication rec {
  pname = "remarkable-mouse";
  version = "7.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-82P9tE3jiUlKBGZCiWDoL+9VJ06Bc+If+aMfcEEU90U=";
  };

  propagatedBuildInputs = with python3Packages; [ screeninfo paramiko pynput libevdev ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "remarkable_mouse" ];

  meta = with lib; {
    description = "Program to use a reMarkable as a graphics tablet";
    homepage = "https://github.com/evidlo/remarkable_mouse";
    license = licenses.gpl3;
    maintainers = [ maintainers.nickhu ];
  };
}

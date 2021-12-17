{ lib, buildPythonApplication, fetchPypi, python3Packages }:

buildPythonApplication rec {
  pname = "remarkable-mouse";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46eff5d6a07ca60ed652d09eeee9b4c4566da422be4a3dfa2fcd452a3df65ac1";
  };

  propagatedBuildInputs = with python3Packages; [ screeninfo paramiko pynput libevdev ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "remarkable_mouse" ];

  meta = with lib; {
    description = "A program to use a reMarkable as a graphics tablet";
    homepage = "https://github.com/evidlo/remarkable_mouse";
    license = licenses.gpl3;
    maintainers = [ maintainers.nickhu ];
  };
}

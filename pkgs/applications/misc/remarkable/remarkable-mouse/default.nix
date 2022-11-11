{ lib, buildPythonApplication, fetchPypi, python3Packages }:

buildPythonApplication rec {
  pname = "remarkable-mouse";
  version = "7.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e6xJBZmWXAPOHNNUMOGLjbe3QmvW0SRwfMNJVZsM3gw=";
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

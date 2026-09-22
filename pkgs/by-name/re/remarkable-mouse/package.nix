{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "remarkable-mouse";
  version = "unstable-2024-02-23";

  src = fetchFromGitHub {
    owner = "Evidlo";
    repo = "remarkable_mouse";
    rev = "05142ef37a8b3f9e350156a14c2dec6844ed0ea8";
    hash = "sha256-0X/7SIfSnlEL98fxJBAYrHAkRmdtymqA7xBmVoa5VIw=";
  };

  pyproject = true;
  build-system = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
    screeninfo
    paramiko
    pynput
    libevdev
    tkinter
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "remarkable_mouse" ];

  meta = {
    description = "Program to use a reMarkable as a graphics tablet";
    homepage = "https://github.com/evidlo/remarkable_mouse";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nickhu ];
  };
}

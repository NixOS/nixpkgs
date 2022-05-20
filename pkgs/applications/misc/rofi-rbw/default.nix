{ lib, buildPythonApplication, fetchFromGitHub, configargparse }:

buildPythonApplication rec {
  pname = "rofi-rbw";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofi-rbw";
    rev = version;
    hash = "sha256-1RDwb8lKls6+X/XtARbi4F7sK4nT03Iy3Wb9N1LEa5o=";
  };

  propagatedBuildInputs = [ configargparse ];

  pythonImportsCheck = [ "rofi_rbw" ];

  meta = with lib; {
    description = "Rofi frontend for Bitwarden";
    homepage = "https://github.com/fdw/rofi-rbw";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
  };
}

{ lib, buildPythonApplication, fetchFromGitHub, configargparse }:

buildPythonApplication rec {
  pname = "rofi-rbw";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofi-rbw";
    rev = "refs/tags/${version}";
    hash = "sha256-BL7aLHKhLAGAT5+NXqzAW2g17XB1PjgRgJuxLh8fFk8=";
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

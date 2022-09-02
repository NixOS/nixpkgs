{ lib, buildPythonApplication, fetchFromGitHub, configargparse }:

buildPythonApplication rec {
  pname = "rofi-rbw";
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofi-rbw";
    rev = "refs/tags/${version}";
    hash = "sha256-YDL0pMl3BX59kzjuykn0lQHu2RMvPhsBrlSiqdcZAXs=";
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

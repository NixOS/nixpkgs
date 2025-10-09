{
  lib,
  python3Packages,
  fetchPypi,
}:

with python3Packages;

buildPythonApplication rec {
  pname = "pirate-get";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VtnVyJqrdGXTqcyzpHCOMUI9G7/BkXzihDrBrsxl7Eg=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = [
    colorama
    veryprettytable
    pyperclip
  ];

  pythonImportsCheck = [ "pirate" ];

  meta = with lib; {
    description = "Command line interface for The Pirate Bay";
    mainProgram = "pirate-get";
    homepage = "https://github.com/vikstrous/pirate-get";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };
}

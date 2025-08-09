{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  click,
  pyfiglet,
  python-dateutil,
  setuptools,
}:

buildPythonApplication rec {
  pname = "termdown";
  version = "1.18.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "trehn";
    repo = "termdown";
    tag = version;
    hash = "sha256-Hnk/MOYdbOl14fI0EFbIq7Hmc7TyhcZWGEg2/jmNJ5Y=";
  };

  dependencies = [
    python-dateutil
    click
    pyfiglet
    setuptools
  ];

  meta = {
    description = "Starts a countdown to or from TIMESPEC";
    mainProgram = "termdown";
    longDescription = "Countdown timer and stopwatch in your terminal";
    homepage = "https://github.com/trehn/termdown";
    license = lib.licenses.gpl3;
  };
}

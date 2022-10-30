{ lib
, fetchFromGitHub
, python3
, qt6
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "maestral-qt";
  version = "1.6.3";
  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-qt";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Fvr5WhrhxPBeAMsrVj/frg01qgt2SeWgrRJYgBxRFHc=";
  };

  format = "pyproject";

  propagatedBuildInputs = with python3.pkgs; [
    click
    markdown2
    maestral
    packaging
    pyqt6
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg  # Needed for the systray icon
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  makeWrapperArgs = with python3.pkgs; [
    # Firstly, add all necessary QT variables
    "\${qtWrapperArgs[@]}"

    # Add the installed directories to the python path so the daemon can find them
    "--prefix PYTHONPATH : ${makePythonPath (requiredPythonModules maestral.propagatedBuildInputs)}"
    "--prefix PYTHONPATH : ${makePythonPath [ maestral ]}"
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "maestral_qt" ];

  passthru.tests.maestral = nixosTests.maestral;

  meta = with lib; {
    description = "GUI front-end for maestral (an open-source Dropbox client) for Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg sfrijters ];
    platforms = platforms.linux;
    homepage = "https://maestral.app";
  };
}

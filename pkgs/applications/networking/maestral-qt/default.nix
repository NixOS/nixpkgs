{ lib
, fetchFromGitHub
, python3
, qtbase
, qtsvg
, qtwayland
, nixosTests
, wrapQtAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "maestral-qt";
  version = "1.8.0";
  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-qt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ys7XrvV4qzq4Q9llua2WgU013Ui0+x+uMwLNIv6xxCw=";
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
    qtwayland
    qtbase
    qtsvg  # Needed for the systray icon
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
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
    homepage = "https://maestral.app";
    changelog = "https://github.com/samschott/maestral/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg sfrijters ];
    platforms = platforms.linux;
    mainProgram = "maestral_qt";
  };
}

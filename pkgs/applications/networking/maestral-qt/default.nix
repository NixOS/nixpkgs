{ lib
, fetchFromGitHub
, python3
, wrapQtAppsHook
, nixosTests
}:

let
  inherit (pypkgs) makePythonPath;

  pypkgs = (python3.override {
    packageOverrides = self: super: {
      # Use last available version of maestral that still supports PyQt5
      # Remove this override when PyQt6 is available
      maestral = super.maestral.overridePythonAttrs (old: rec {
        version = "1.5.3";
        src = fetchFromGitHub {
          owner = "SamSchott";
          repo = "maestral";
          rev = "refs/tags/v${version}";
          hash = "sha256-Uo3vcYez2qSq162SSKjoCkwygwR5awzDceIq8/h3dao=";
        };
      });
    };
  }).pkgs;

in
pypkgs.buildPythonApplication rec {
  pname = "maestral-qt";
  version = "1.5.3";
  disabled = pypkgs.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-qt";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-zaG9Zwz9S/SVb7xDa7eXkjLNt1BhA1cQ3I18rVt+8uQ=";
  };

  format = "pyproject";

  propagatedBuildInputs = with pypkgs; [
    click
    markdown2
    maestral
    packaging
    pyqt5
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  makeWrapperArgs = [
    # Firstly, add all necessary QT variables
    "\${qtWrapperArgs[@]}"

    # Add the installed directories to the python path so the daemon can find them
    "--prefix PYTHONPATH : ${makePythonPath (pypkgs.requiredPythonModules pypkgs.maestral.propagatedBuildInputs)}"
    "--prefix PYTHONPATH : ${makePythonPath [ pypkgs.maestral ]}"
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

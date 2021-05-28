{ stdenv
, lib
, fetchFromGitHub
, python3
, wrapQtAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "maestral-qt";
  version = "1.2.1";
  disabled = python3.pkgs.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-qt";
    rev = "v${version}";
    sha256 = "sha256-7qpVyQUbT+GChJl1TnKOONSyRDvzQ0M2z9RdN7PNl9U=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    bugsnag
    click
    markdown2
    maestral
    packaging
    pyqt5
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  makeWrapperArgs = [
    # Firstly, add all necessary QT variables
    "\${qtWrapperArgs[@]}"

    # Add the installed directories to the python path so the daemon can find them
    "--prefix" "PYTHONPATH" ":" "${stdenv.lib.concatStringsSep ":" (map (p: p + "/lib/${python3.libPrefix}/site-packages") (python3.pkgs.requiredPythonModules python3.pkgs.maestral.propagatedBuildInputs))}"
    "--prefix" "PYTHONPATH" ":" "${python3.pkgs.maestral}/lib/${python3.libPrefix}/site-packages"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "GUI front-end for maestral (an open-source Dropbox client) for Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    inherit (src.meta) homepage;
  };
}

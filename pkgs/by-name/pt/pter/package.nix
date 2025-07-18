{
  lib,
  stdenv,
  fetchFromGitea,
  python311Packages,
  python3Packages,
  qt5,
  withQt ? false,
}:
let
  # Use python311Packages on Darwin due to ncurses being disabled in newer versions
  pythonPkgs = if stdenv.isDarwin then python311Packages else python3Packages;
in
pythonPkgs.buildPythonApplication rec {
  pname = "pter";
  version = "3.20.1";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "vonshednob";
    repo = "pter";
    tag = "v${version}";
    hash = "sha256-1TJ3MembAMB3sewlZE0G8vI8HFrSjEIdIKq5J51P40g=";
  };

  build-system = with pythonPkgs; [
    docutils
    setuptools
  ];

  nativeBuildInputs = lib.optionals withQt [ qt5.wrapQtAppsHook ];

  dependencies =
    with pythonPkgs;
    [
      cursedspace
      pytodotxt
    ]
    ++ lib.optionals withQt [ pyqt5 ];

  nativeCheckInputs = [ pythonPkgs.unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  dontWrapQtApps = true;

  preFixup = lib.optionalString withQt ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "Manage your todo.txt in a commandline user interface";
    homepage = "https://vonshednob.cc/pter/";
    license = lib.licenses.mit;
    mainProgram = if withQt then "qpter" else "pter";
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}

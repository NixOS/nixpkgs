{ lib
, fetchFromGitHub
, python3Packages
, wrapGAppsHook
, qt5
}:

python3Packages.buildPythonApplication rec {
  pname = "buttermanager";
  version = "2.5.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "egara";
    repo = "buttermanager";
    rev = version;
    hash = "sha256-MLYJt7OMYlTFk8FCAlZJ1RGlFFXKfeAthWGp4JN+PfY=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyqt5
    pyyaml
    sip
    tkinter
    setuptools
  ];

  nativeBuildInputs = [ wrapGAppsHook qt5.wrapQtAppsHook ];

  dontWrapQtApps = true;
  dontWrapGApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" "\${gappsWrapperArgs[@]}"];

  meta = with lib; {
    description = "Btrfs tool for managing snapshots, balancing filesystems and upgrading the system safetly";
    homepage = "https://github.com/egara/buttermanager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "buttermanager";
  };
}

{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pyqt5,
  qt5,
  git-annex-adapter,
}:

buildPythonApplication rec {
  pname = "git-annex-metadata-gui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "alpernebbi";
    repo = "git-annex-metadata-gui";
    rev = "v${version}";
    sha256 = "03kch67k0q9lcs817906g864wwabkn208aiqvbiyqp1qbg99skam";
  };

  prePatch = ''
    substituteInPlace setup.py --replace "'PyQt5', " ""
  '';

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  propagatedBuildInputs = [
    pyqt5
    git-annex-adapter
  ];

  meta = with lib; {
    homepage = "https://github.com/alpernebbi/git-annex-metadata-gui";
    description = "Graphical interface for git-annex metadata commands";
    mainProgram = "git-annex-metadata-gui";
    maintainers = with maintainers; [ dotlambda ];
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
  };
}

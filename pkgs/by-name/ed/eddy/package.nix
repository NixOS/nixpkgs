{
  python3Packages,
  fetchFromGitHub,
  lib,
  jre,
  qt5,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "eddy";
  version = "3.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "obdasystems";
    repo = "eddy";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-l27FN8Rxhg5hTq4SfJliHxYWq55ix8keGM887fWbtQ4=";
  };

  propagatedBuildInputs = [
    qt5.qtbase
    qt5.wrapQtAppsHook
    python3Packages.setuptools
    python3Packages.rfc3987
    python3Packages.jpype1
    python3Packages.pyqt5
  ];

  # Tests fail with: ImportError: cannot import name 'QtXmlPatterns' from 'PyQt5'
  doCheck = false;

  preBuild = ''
    export HOME=/tmp
  '';

  preFixup = ''
    wrapQtApp "$out/bin/eddy" --prefix JAVA_HOME : ${jre}
  '';

  meta = {
    homepage = "http://www.obdasystems.com/eddy";
    description = "Graphical editor for the specification and visualization of Graphol ontologies";
    mainProgram = "eddy";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ koslambrou ];
  };
})

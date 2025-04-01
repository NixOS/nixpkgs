{
  python3Packages,
  fetchFromGitHub,
  lib,
  jre,
  qt5,
  wrapQtAppsHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "eddy";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "obdasystems";
    repo = pname;
    rev = "v${version}";
    sha256 = "12j77bbva5py9bd57c80cmjvf8vll40h19n81h16lvv2r2r7jynh";
  };

  propagatedBuildInputs = [
    qt5.qtbase
    wrapQtAppsHook
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

  meta = with lib; {
    homepage = "http://www.obdasystems.com/eddy";
    description = "Graphical editor for the specification and visualization of Graphol ontologies";
    mainProgram = "eddy";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ koslambrou ];
  };
}

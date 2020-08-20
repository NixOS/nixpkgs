{ python37Packages
, fetchFromGitHub
, lib
, jre
, qt5
}:

python37Packages.buildPythonApplication rec {
  pname = "eddy";
  version = "2020-04-16";

  src = fetchFromGitHub {
    owner = "obdasystems";
    repo = "${pname}";
    rev = "4514b72ea21d910af8102b5a3c17ffff32b5fa6e";
    sha256 = "sha256:18hwdg70y2id4s9i46ypvnihzldkn9awz6wxf0c59q5jxjqrs1ca";
  };

  propagatedBuildInputs = [
    qt5.full
    python37Packages.setuptools
    python37Packages.rfc3987
    python37Packages.JPype1
    python37Packages.pyqt5
  ];

  doCheck = false;

  HOME = "/tmp";

  preFixup = ''
    wrapProgram $out/bin/eddy --prefix JAVA_HOME ":" ${jre};
  '';

  meta = with lib; {
    homepage = "http://www.obdasystems.com/eddy";
    description = "Graphical editor for the specification and visualization of Graphol ontologies";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.koslambrou ];
  };
}

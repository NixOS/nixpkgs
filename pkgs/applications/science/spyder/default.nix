{ stdenv, fetchurl, unzip, buildPythonPackage, makeDesktopItem
# mandatory
, pyside
# recommended
, pyflakes ? null, rope ? null, sphinx ? null, numpy ? null, scipy ? null, matplotlib ? null
# optional
, ipython ? null, pylint ? null, pep8 ? null
}:

buildPythonPackage rec {
  name = "spyder-${version}";
  version = "2.3.7";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/s/spyder/${name}.zip";
    sha256 = "0ywgvgcp9s64ys25nfscd2648f7di8544a21b5lb59d4f48z028h";
  };

  # NOTE: sphinx makes the build fail with: ValueError: ZIP does not support timestamps before 1980
  propagatedBuildInputs =
    [ pyside pyflakes rope  numpy scipy matplotlib ipython pylint pep8 ];

  # There is no test for spyder
  doCheck = false;

  desktopItem = makeDesktopItem {
    name = "Spyder";
    exec = "spyder";
    icon = "spyder";
    comment = "Scientific Python Development Environment";
    desktopName = "Spyder";
    genericName = "Python IDE";
    categories = "Application;Development;Editor;IDE;";
  };

  # Create desktop item
  postInstall = ''
    mkdir -p $out/share/{applications,icons}
    cp  $desktopItem/share/applications/* $out/share/applications/
    cp  spyderlib/images/spyder.svg $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = https://github.com/spyder-ide/spyder/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor fridh ];
  };
}

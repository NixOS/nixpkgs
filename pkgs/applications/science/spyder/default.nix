{ stdenv, fetchPypi, unzip, buildPythonApplication, makeDesktopItem
# mandatory
, numpydoc, qtconsole, qtawesome, jedi, pycodestyle, psutil
, pyflakes, rope, sphinx, nbconvert, mccabe, pyopengl, cloudpickle
# optional
, numpy ? null, scipy ? null, matplotlib ? null
# optional
, pylint ? null
}:

buildPythonApplication rec {
  pname = "spyder";
  version = "3.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5bb8fe0a556930dc09b68fa2741a0de3da6488843ec960e0c62f1f3b2e08e2f";
  };

  # Somehow setuptools can't find pyqt5. Maybe because the dist-info folder is missing?
  postPatch = ''
    substituteInPlace setup.py --replace 'pyqt5;python_version>="3"' ' '
  '';

  propagatedBuildInputs = [
    jedi pycodestyle psutil pyflakes rope numpy scipy matplotlib pylint
    numpydoc qtconsole qtawesome nbconvert mccabe pyopengl cloudpickle
  ];

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
    mkdir -p $out/share/icons
    cp spyder/images/spyder.svg $out/share/icons
    cp -r $desktopItem/share/applications/ $out/share
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
  };
}

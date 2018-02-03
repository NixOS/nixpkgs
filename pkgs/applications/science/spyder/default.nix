{ stdenv, fetchPypi, unzip, buildPythonApplication, makeDesktopItem
# mandatory
, qtpy, numpydoc, qtconsole, qtawesome, jedi, pycodestyle, psutil
, pyflakes, rope, sphinx, nbconvert, mccabe
# optional
, numpy ? null, scipy ? null, matplotlib ? null
# optional
, pylint ? null
}:

buildPythonApplication rec {
  pname = "spyder";
  version = "3.2.6";
  namePrefix = "";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87d6a4f5ee1aac4284461ee3584c3ade50cb53feb3fe35abebfdfb9be18c526a";
  };

  propagatedBuildInputs = [
    jedi pycodestyle psutil qtpy pyflakes rope numpy scipy matplotlib pylint
    numpydoc qtconsole qtawesome nbconvert mccabe
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

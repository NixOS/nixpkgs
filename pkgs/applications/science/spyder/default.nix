{ stdenv, fetchurl, unzip, buildPythonPackage, makeDesktopItem
# mandatory
, pyside
# recommended
, pyflakes ? null, rope ? null, sphinx ? null, numpy ? null, scipy ? null, matplotlib ? null
# optional
, ipython ? null, pylint ? null, pep8 ? null
}:

buildPythonPackage rec {
  name = "spyder-2.1.13.1";
  namePrefix = "";

  src = fetchurl {
    url = "https://spyderlib.googlecode.com/files/${name}.zip";
    sha256 = "1sg88shvw6k2v5428k13mah4pyqng43856rzr6ypz5qgwn0677ya";
  };

  buildInputs = [ unzip ];
  propagatedBuildInputs =
    [ pyside pyflakes rope sphinx numpy scipy matplotlib ipython pylint pep8 ];

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
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications/

    mkdir -p $out/share/icons
    cp spyderlib/images/spyder.svg $out/share/icons/
  '';

  meta = {
    description = "Scientific PYthon Development EnviRonment (SPYDER)";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = https://code.google.com/p/spyderlib/;
    license = stdenv.lib.licenses.mit;
  };
}

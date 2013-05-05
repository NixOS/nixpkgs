{ stdenv, fetchurl, buildPythonPackage, unzip, sphinx, pyside }:

buildPythonPackage rec {
  name = "spyder-2.1.13.1";
  namePrefix = "";

  src = fetchurl {
    url = "https://spyderlib.googlecode.com/files/${name}.zip";
    sha256 = "1sg88shvw6k2v5428k13mah4pyqng43856rzr6ypz5qgwn0677ya";
  };

  buildInputs = [ unzip sphinx ];
  propagatedBuildInputs = [ pyside ];

  # There is no test for spyder
  doCheck = false;

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

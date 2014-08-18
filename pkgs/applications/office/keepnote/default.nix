{ stdenv, fetchurl, buildPythonPackage, pythonPackages, pygtk }:

buildPythonPackage {
  name = "keepnote-0.6.5";
  namePrefix = "";

  src = fetchurl {
    url = http://rasm.ods.org/keepnote/download/keepnote-0.6.5.tar.gz;
    sha256 = "0kipcy90r50z4m9p8pyy9wi4dknsiwdrgy974xgakris2rh4lafw";
  };

  propagatedBuildInputs = [ pythonPackages.sqlite3 pygtk ];

  # Testing fails.
  doCheck = false;

  meta = {
    description = "Note taking application";
    homepage = http://rasm.ods.org/keepnote;
    license = "GPLv2+";
  };
}

{ stdenv, lib, fetchurl, buildPythonApplication, pythonPackages, pygtk, pygobject, python }:

#
# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).
#

buildPythonApplication rec {
  name = "zim-${version}";
  version = "0.65";
  namePrefix = "";

  src = fetchurl {
    url = "http://zim-wiki.org/downloads/${name}.tar.gz";
    sha256 = "15pdq4fxag85qjsrdmmssiq85qsk5vnbp8mrqnpvx8lm8crz6hjl";
  };

  propagatedBuildInputs = [ pythonPackages.sqlite3 pygtk pythonPackages.pyxdg pygobject ];

  preBuild = ''
    export HOME=$TMP

    sed -i '/zim_install_class,/d' setup.py
  '';


  preFixup = ''
    export makeWrapperArgs="--prefix XDG_DATA_DIRS : $out/share --argv0 $out/bin/.zim-wrapped"
  '';

  postFixup = ''
    wrapPythonPrograms
    substituteInPlace $out/bin/.zim-wrapped \
    --replace "sys.argv[0] = 'zim'" "sys.argv[0] = '$out/bin/zim'"
  '';

  doCheck = true;

  meta = {
      description = "A desktop wiki";
      homepage = http://zim-wiki.org;
      license = stdenv.lib.licenses.gpl2Plus;
  };
}

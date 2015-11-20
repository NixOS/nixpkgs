{ stdenv, lib, fetchurl, buildPythonPackage, pythonPackages, pygtk, pygobject, python }:

#
# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).
#

buildPythonPackage rec {
  name = "zim-${version}";
  version = "0.63";
  namePrefix = "";

  src = fetchurl {
    url = "http://zim-wiki.org/downloads/${name}.tar.gz";
    sha256 = "077vf4h0hjmbk8bxj9l0z9rxcb3dw642n32lvfn6vjdna1qm910m";
  };

  propagatedBuildInputs = [ pythonPackages.sqlite3 pygtk pythonPackages.pyxdg pygobject ];

  preBuild = ''
    mkdir -p /tmp/home
    export HOME="/tmp/home"

    sed -i '/zim_install_class,/d' setup.py
  '';


  preFixup = ''
    export makeWrapperArgs="--prefix XDG_DATA_DIRS : $out/share --argv0 $out/bin/.zim-wrapped"
  '';
  # Testing fails.
  doCheck = false;

  meta = {
      description = "A desktop wiki";
      homepage = http://zim-wiki.org;
      license = stdenv.lib.licenses.gpl2Plus;
  };
}

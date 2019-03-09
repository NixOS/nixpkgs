{ stdenv, fetchurl, python2Packages }:

#
# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).
#

python2Packages.buildPythonApplication rec {
  name = "zim-${version}";
  version = "0.69.1";

  src = fetchurl {
    url = "http://zim-wiki.org/downloads/${name}.tar.gz";
    sha256 = "1yzb8x4mjp96zshcw7xbd4mvqn8zmbcm7cndskpxyk5yccyn5awq";
  };

  propagatedBuildInputs = with python2Packages; [ pyGtkGlade pyxdg pygobject2 ];

  preBuild = ''
    export HOME=$TMP

    sed -i '/zim_install_class,/d' setup.py
  '';


  preFixup = ''
    export makeWrapperArgs="--prefix XDG_DATA_DIRS : $out/share --argv0 $out/bin/.zim-wrapped"
  '';

  # RuntimeError: could not create GtkClipboard object
  doCheck = false;

  checkPhase = ''
    python test.py
  '';


  meta = with stdenv.lib; {
    description = "A desktop wiki";
    homepage = http://zim-wiki.org;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    broken = stdenv.isDarwin; # https://github.com/NixOS/nixpkgs/pull/52658#issuecomment-449565790
  };
}

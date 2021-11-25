{ lib, stdenv, fetchurl, python3Packages, gtk3, gobject-introspection, wrapGAppsHook, gnome }:

# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).

python3Packages.buildPythonApplication rec {
  pname = "zim";
  version = "0.74.2";

  src = fetchurl {
    url = "https://zim-wiki.org/downloads/zim-${version}.tar.gz";
    sha256 = "sha256-tZxBlpps2nLThSOq3WJ42iUQ4NG1Lb463bvDQ+djZJA=";
  };

  buildInputs = [ gtk3 gobject-introspection wrapGAppsHook gnome.adwaita-icon-theme ];
  propagatedBuildInputs = with python3Packages; [ pyxdg pygobject3 ];

  preFixup = ''
    export makeWrapperArgs="--prefix XDG_DATA_DIRS : $out/share --argv0 $out/bin/.zim-wrapped"
  '';

  # RuntimeError: could not create GtkClipboard object
  doCheck = false;

  checkPhase = ''
    ${python3Packages.python.interpreter} test.py
  '';

  meta = with lib; {
    description = "A desktop wiki";
    homepage = "https://zim-wiki.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    broken = stdenv.isDarwin; # https://github.com/NixOS/nixpkgs/pull/52658#issuecomment-449565790
  };
}

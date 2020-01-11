{ stdenv, fetchurl, python3Packages, gtk3, gobject-introspection, wrapGAppsHook, gnome3 }:

#
# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).
#

python3Packages.buildPythonApplication rec {
  name = "zim-${version}";
  version = "0.72.0";

  src = fetchurl {
    url = "http://zim-wiki.org/downloads/${name}.tar.gz";
    sha256 = "1n3gmg7g86s8iwcx0i7rvvfdfs1fzmc9awr9qzjd2rckw4bkxad1";
  };

  buildInputs = [ gtk3 gobject-introspection wrapGAppsHook gnome3.adwaita-icon-theme ];
  propagatedBuildInputs = with python3Packages; [ pyxdg pygobject3 ];


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

{ lib, stdenv, fetchurl, python3Packages, gtk3, gobject-introspection, wrapGAppsHook, gnome }:

#
# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).
#

python3Packages.buildPythonApplication rec {
  name = "zim-${version}";
  version = "0.73.1";

  src = fetchurl {
    url = "https://zim-wiki.org/downloads/${name}.tar.gz";
    sha256 = "13vhwsgv6mscgixypc0ixkgj0y7cpcm7z7wn1vmdrwp7kn8m3xgx";
  };

  buildInputs = [ gtk3 gobject-introspection wrapGAppsHook gnome.adwaita-icon-theme ];
  propagatedBuildInputs = with python3Packages; [ pyxdg pygobject3 ];


  preFixup = ''
    export makeWrapperArgs="--prefix XDG_DATA_DIRS : $out/share --argv0 $out/bin/.zim-wrapped"
  '';

  # RuntimeError: could not create GtkClipboard object
  doCheck = false;

  checkPhase = ''
    python test.py
  '';


  meta = with lib; {
    description = "A desktop wiki";
    homepage = "http://zim-wiki.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    broken = stdenv.isDarwin; # https://github.com/NixOS/nixpkgs/pull/52658#issuecomment-449565790
  };
}

{ lib, stdenv, fetchurl, python3Packages, gtk3, gobject-introspection, wrapGAppsHook, gnome }:

# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).

python3Packages.buildPythonApplication rec {
  pname = "zim";
  version = "0.74.3";

  src = fetchurl {
    url = "https://zim-wiki.org/downloads/zim-${version}.tar.gz";
    sha256 = "sha256-3ehPIkhsf1JnC9Qx3kQ6ilvRaBB7auBm2C1HOuNGzRU=";
  };

  buildInputs = [ gtk3 gobject-introspection gnome.adwaita-icon-theme ];
  propagatedBuildInputs = with python3Packages; [ pyxdg pygobject3 ];
  # see https://github.com/NixOS/nixpkgs/issues/56943#issuecomment-1131643663
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(--prefix XDG_DATA_DIRS : $out/share)
    makeWrapperArgs+=(--argv0 $out/bin/.zim-wrapped)
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # RuntimeError: could not create GtkClipboard object
  doCheck = false;

  checkPhase = ''
    ${python3Packages.python.interpreter} test.py
  '';

  meta = with lib; {
    description = "A desktop wiki";
    homepage = "https://zim-wiki.org/";
    changelog = "https://github.com/zim-desktop-wiki/zim-desktop-wiki/blob/${version}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    broken = stdenv.isDarwin; # https://github.com/NixOS/nixpkgs/pull/52658#issuecomment-449565790
  };
}

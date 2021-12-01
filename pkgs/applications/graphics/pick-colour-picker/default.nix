{ lib
, fetchFromGitHub
, buildPythonPackage
, pygobject3
, pycairo
, glib
, gtk3
, gobject-introspection
, wrapGAppsHook
, python
}:

buildPythonPackage rec {
  pname = "pick-colour-picker";
  version = "unstable-2021-01-19";

  src = fetchFromGitHub {
    owner = "stuartlangridge";
    repo = "ColourPicker";
    rev = "dec8f144918aa7964aaf86a346161beb7e997f09";
    sha256 = "hW2rarfchZ3M0JVfz5RbJRvMhv2PpyLNEMyMAp2gC+o=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  pythonPath = [
    pygobject3
    pycairo
  ];

  buildInputs = [
    glib
    gtk3
  ];

  # https://github.com/NixOS/nixpkgs/issues/56943
  # this must be false, otherwise the gobject-introspection hook doesn't run
  strictDeps = false;

  preDistPhases = [ "fixupIconPath" ];

  fixupIconPath = ''
    pickLoc="$out/${python.sitePackages}/pick"
    shareLoc=$(echo "$out/${python.sitePackages}/nix/store/"*)
    mv "$shareLoc/share" "$out/share"

    sed "s|os.environ.get('SNAP'), \"usr\"|'$out'|g" -i "$pickLoc/__main__.py"
    '';

  meta = with lib; {
    homepage = "https://kryogenix.org/code/pick/";
    license = licenses.mit;
    platforms = platforms.linux;
    description = "A colour picker that remembers where you picked colours from";
    maintainers = [ maintainers.mkg20001 ];

    longDescription = ''
      Pick lets you pick colours from anywhere on your screen. Choose the colour you want and Pick remembers it, names it, and shows you a screenshot so you can remember where you got it from.

      Zoom all the way in to pixels to pick just the right one. Show your colours in your choice of format: rgba() or hex, CSS or Gdk or Qt, whichever you prefer. Copy to the clipboard ready for pasting into code or graphics apps.
      '';
  };
}

{ lib
, fetchFromGitHub
, buildPythonPackage
, pygobject3
, pycairo
, glib
, gtk3
, gobject-introspection
, wrapGAppsHook3
, python
}:

buildPythonPackage rec {
  pname = "pick-colour-picker";
  version = "unstable-2022-05-08";

  src = fetchFromGitHub {
    owner = "stuartlangridge";
    repo = "ColourPicker";
    rev = "e3e4c2bcec5d7285425582b92bb564c74be2cf77";
    hash = "sha256-vW8mZiB3JFQtbOCWauhJGfZMlGsA/nNcljNNPtJtgGw=";
  };

  postPatch = ''
    sed "s|sys\.prefix|'\.'|g" -i setup.py
    sed "s|os.environ.get(\"SNAP\")|'$out'|g" -i pick/__main__.py
    sed "s|os.environ.get('SNAP'), \"usr\"|'$out'|g" -i pick/__main__.py
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  pythonPath = [
    pygobject3
    pycairo
  ];

  buildInputs = [
    glib
    gtk3
  ];

  meta = with lib; {
    homepage = "https://kryogenix.org/code/pick/";
    license = licenses.mit;
    platforms = platforms.linux;
    description = "Colour picker that remembers where you picked colours from";
    mainProgram = "pick-colour-picker";
    maintainers = [ maintainers.mkg20001 ];

    longDescription = ''
      Pick lets you pick colours from anywhere on your screen. Choose the colour you want and Pick remembers it, names it, and shows you a screenshot so you can remember where you got it from.

      Zoom all the way in to pixels to pick just the right one. Show your colours in your choice of format: rgba() or hex, CSS or Gdk or Qt, whichever you prefer. Copy to the clipboard ready for pasting into code or graphics apps.
      '';
  };
}

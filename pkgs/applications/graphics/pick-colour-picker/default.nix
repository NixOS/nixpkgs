{ stdenv
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
  version = "unstable-2019-10-11"; # "1.5.0-3ec940"

  src = fetchFromGitHub {
    owner = "stuartlangridge";
    repo = "ColourPicker";
    rev = "3ec9406d787ce373f6db0d520ed38a921edb9473";
    sha256 = "04l8ch9297nhkgcmyhsbg0il424c8vy0isns1c7aypn0zp0dc4zd";
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

  meta = with stdenv.lib; {
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

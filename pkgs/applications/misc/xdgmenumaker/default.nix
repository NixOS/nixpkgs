{ lib
, fetchFromGitHub
, atk
, gdk-pixbuf
, gobject-introspection
, pango
, python3Packages
, txt2tags
, wrapGAppsHook
, gitUpdater
}:

python3Packages.buildPythonApplication rec {
  pname = "xdgmenumaker";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "gapan";
    repo = pname;
    rev = version;
    sha256 = "Q38m8YrvkkTCY2dByvPj+Ee1DMSUbWvwSDI0kW182bU=";
  };

  format = "other";

  strictDeps = false;

  dontWrapGApps = true;

  nativeBuildInputs = [
    gobject-introspection
    txt2tags
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    gdk-pixbuf
    pango
  ];

  pythonPath = with python3Packages; [
    pygobject3
    pyxdg
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = gitUpdater {inherit pname version; };

  meta = with lib; {
    description = "Command line tool that generates XDG menus for several window managers";
    homepage = "https://github.com/gapan/xdgmenumaker";
    license = licenses.gpl3Plus;
    # NOTE: exclude darwin from platforms because Travis reports hash mismatch
    platforms = with platforms; filter (x: !(elem x darwin)) unix;
    maintainers = [ maintainers.romildo ];
  };
}

{ stdenv, fetchFromGitHub, txt2tags, python3Packages, glib, gobject-introspection, wrapGAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "xdgmenumaker";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "gapan";
    repo = pname;
    rev = version;
    sha256 = "1vrsp5c1ah7p4dpwd6aqvinpwzd8crdimvyyr3lbm3c6cwpyjmif";
  };

  format = "other";

  strictDeps = false;

  nativeBuildInputs = [
    gobject-introspection
    txt2tags
    wrapGAppsHook
  ];

  buildInputs = [
    glib
  ];

  pythonPath = with python3Packages; [
    pyxdg
    pygobject3
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  installFlags = [
    "DESTDIR="
  ];

  meta = with stdenv.lib; {
    description = "Command line tool that generates XDG menus for several window managers";
    homepage = https://github.com/gapan/xdgmenumaker;
    license = licenses.gpl2Plus;
    # NOTE: exclude darwin from platforms because Travis reports hash mismatch
    platforms = with platforms; filter (x: !(elem x darwin)) unix;
    maintainers = [ maintainers.romildo ];
  };
}

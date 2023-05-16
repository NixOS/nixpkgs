{ lib
, python3
, fetchFromGitHub
, meson
, ninja
, gettext
, appstream
, appstream-glib
, wrapGAppsHook
, desktop-file-utils
, gobject-introspection
, gtksourceview4
, gspell
, libhandy
, poppler_gi
, webkitgtk_4_1
, librsvg
<<<<<<< HEAD
, libportal
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "setzer";
<<<<<<< HEAD
  version = "56";
=======
  version = "55";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Setzer";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YCJu8EU+8RD09QNVT/RYF2ZJZ7cp+oawXThqTzg8ENQ=";
=======
    hash = "sha256-Mcl9kWeo4w/wW8crR58Yyqoh26w8/SmNrjmHps6DmRA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  format = "other";

  nativeBuildInputs = [
    meson
    ninja
    gettext
    appstream # for appstreamcli
    appstream-glib
    wrapGAppsHook
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gtksourceview4
    gspell
    libhandy
    poppler_gi
    webkitgtk_4_1
    librsvg
<<<<<<< HEAD
    libportal
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pyxdg
    pdfminer-six
    pycairo
    pexpect
<<<<<<< HEAD
    bibtexparser
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  checkPhase = ''
    meson test --print-errorlogs
  '';

  meta = with lib; {
    description = "LaTeX editor written in Python with Gtk";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

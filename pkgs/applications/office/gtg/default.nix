{ lib, stdenv
, fetchFromGitHub
, meson
, python3Packages
, ninja
, gtk3
, wrapGAppsHook
, glib
, itstool
, gettext
, pango
, gdk-pixbuf
, gobject-introspection
, xvfb_run
}:

python3Packages.buildPythonApplication rec {
  pname = "gtg";
  version = "unstable-2020-10-22";

  src = fetchFromGitHub {
    owner = "getting-things-gnome";
    repo = "gtg";
    rev = "144814c16723fa9d00e17e047df5d79ab443fc5f";
    sha256 = "1lpanfbj8y8b6cqp92lgbvfs8irrc5bsdffzcjcycazv19qm7z2n";
  };


  nativeBuildInputs = [
    meson
    ninja
    itstool
    gettext
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    pango
    gdk-pixbuf
  ];

  propagatedBuildInputs = with python3Packages; [
    pycairo
    pygobject3
    lxml
    gst-python
    liblarch
  ];

  checkInputs = with python3Packages; [
    nose
    mock
    xvfb_run
  ];

  format = "other";
  strictDeps = false; # gobject-introspection does not run with strictDeps (https://github.com/NixOS/nixpkgs/issues/56943)

  checkPhase = "xvfb-run python3 ../run-tests";

  meta = with lib; {
    description = " A personal tasks and TODO-list items organizer";
    longDescription = ''
      "Getting Things GNOME" (GTG) is a personal tasks and ToDo list organizer inspired by the "Getting Things Done" (GTD) methodology.
      GTG is intended to help you track everything you need to do and need to know, from small tasks to large projects.
    '';
    homepage = "https://wiki.gnome.org/Apps/GTG";
    downloadPage = "https://github.com/getting-things-gnome/gtg/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ oyren ];
    platforms = platforms.linux;
  };
}

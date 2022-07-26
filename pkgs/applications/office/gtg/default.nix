{ lib
, fetchFromGitHub
, fetchpatch
, meson
, python3Packages
, ninja
, gtk3
, wrapGAppsHook
, glib
, gtksourceview4
, itstool
, gettext
, pango
, gdk-pixbuf
, libsecret
, gobject-introspection
, xvfb-run
}:

python3Packages.buildPythonApplication rec {
  pname = "gtg";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "getting-things-gnome";
    repo = "gtg";
    rev = "v${version}";
    sha256 = "sha256-O8qBD92P2g8QrBdMXa6j0Ozk+W80Ny5yk0KNTy7ekfE=";
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
    gtksourceview4
    pango
    gdk-pixbuf
    libsecret
  ];

  propagatedBuildInputs = with python3Packages; [
    pycairo
    pygobject3
    lxml
    gst-python
    liblarch
    caldav
  ];

  checkInputs = with python3Packages; [
    nose
    mock
    xvfb-run
    pytest
  ];

  preBuild = ''
    export HOME="$TMP"
  '';

  format = "other";
  strictDeps = false; # gobject-introspection does not run with strictDeps (https://github.com/NixOS/nixpkgs/issues/56943)

  checkPhase = "xvfb-run pytest ../tests/";

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

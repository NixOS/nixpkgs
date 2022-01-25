{ lib
, fetchFromGitHub
, fetchpatch
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
, xvfb-run
}:

python3Packages.buildPythonApplication rec {
  pname = "gtg";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "getting-things-gnome";
    repo = "gtg";
    rev = "v${version}";
    sha256 = "0b2slm7kjq6q8c7v4m7aqc8m1ynjxn3bl7445srpv1xc0dilq403";
  };

  patches = [
    # fix build with meson 0.60 (https://github.com/getting-things-gnome/gtg/pull/729)
    (fetchpatch {
      url = "https://github.com/getting-things-gnome/gtg/commit/1809d10663ae3d8f69c04138b66f9b4e66ee14f6.patch";
      sha256 = "sha256-bYr5PAsuvcSqTf0vaJj2APtuBrwHdhXJxtXoAb7CfGk=";
    })
  ];

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
    xvfb-run
  ];

  preBuild = ''
    export HOME="$TMP"
  '';

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

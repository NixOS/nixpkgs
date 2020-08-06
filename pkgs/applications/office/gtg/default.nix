{ stdenv
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
}:

python3Packages.buildPythonApplication rec {
  pname = "gtg";
  version = "unstable-2020-08-02";

  src = fetchFromGitHub {
    owner = "getting-things-gnome";
    repo = "gtg";
    rev = "6623731f301c1b9c7b727e009f4a6462ad381c68";
    sha256 = "14gxgg4nl0ki3dn913041jpyfhxsj90fkd55z6mmpyklhr8mwss1";
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
    dbus-python
    gst-python
    liblarch
  ];

  format = "other";
  strictDeps = false; # gobject-introspection does not run with strictDeps (https://github.com/NixOS/nixpkgs/issues/56943)

  meta = with stdenv.lib; {
    description = " A personal tasks and TODO-list items organizer.";
    longDescription = ''
      "Getting Things GNOME" (GTG) is a personal tasks and ToDo list organizer inspired by the "Getting Things Done" (GTD) methodology.
      GTG is intended to help you track everything you need to do and need to know, from small tasks to large projects.
    '';
    homepage = "https://wiki.gnome.org/Apps/GTG";
    downloadPage = "https://github.com/getting-things-gnome/gtg/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oyren ];
    platforms = platforms.linux;
  };
}

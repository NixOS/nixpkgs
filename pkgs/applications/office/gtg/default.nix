{ stdenv
, fetchFromGitHub
, meson
, python3Packages
, pkgconfig
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
  version = "0.4";

  src = fetchFromGitHub {
      owner = "getting-things-gnome";
      repo = "gtg";
      rev = "6623731f301c1b9c7b727e009f4a6462ad381c68";
      sha256 = "14gxgg4nl0ki3dn913041jpyfhxsj90fkd55z6mmpyklhr8mwss1";
  };


  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    itstool
    gettext
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
    pyxdg # can probably be removed after next release
  ];

  format = "other";
  strictDeps = false;

  meta = with stdenv.lib; {
    description = "
      Getting Things GNOME! (GTG) is a personal tasks and TODO-list items organizer for the GNOME desktop environment and inspired by the ''Getting Things Done'' (GTD) methodology.
    ";
    longDescription = "
      GTG is designed with flexibility, adaptability, and ease of use in mind so it can be used as more than just GTD software.
      GTG is intended to help you track everything you need to do and need to know, from small tasks to large projects.
    ";
    homepage = "https://wiki.gnome.org/Apps/GTG";
    downloadPage = "https://github.com/getting-things-gnome/gtg/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oyren ];
    platforms = [ "x86_64-linux" ];
  };
}

{ stdenv, fetchFromGitLab, lib, pkgs }:

let
  pname = "giara";
  version = "0.2";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    sha256 = "1ca7ldf0rd19aixbdjvamqs55f3iig9wahgczik24r6knxj1bxl4";
  };
in

stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = with pkgs; [
    meson gobject-introspection pkg-config ninja python3 python3Packages.wrapPython wrapGAppsHook
  ];

  buildInputs = with pkgs; [
    gtk3 webkitgtk gtksourceview4 libhandy glib-networking
  ];

  pythonPath = with pkgs.python3Packages; [
    pygobject3 dateutil praw pillow mistune beautifulsoup4
  ];

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "A Reddit app, built with Python, GTK and Handy. Created with mobile Linux in mind.";
    maintainers = with maintainers; [ atemu ];
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

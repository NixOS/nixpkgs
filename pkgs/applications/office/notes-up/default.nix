{ stdenv, fetchFromGitHub, pantheon, pkgconfig, cmake, ninja, gtk3, gtksourceview3, webkitgtk, gtkspell3, glib, libgee, sqlite, discount, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "notes-up";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Notes-up";
    rev = version;
    sha256 = "06fzdb823kkami0jch9ccblsvw3x7zd1d4xz8fv3giscl3f36x4q";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pantheon.vala
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    discount
    glib
    gtk3
    gtksourceview3
    gtkspell3
    libgee
    pantheon.granite
    sqlite
    webkitgtk
  ];

  meta = with stdenv.lib; {
    description = "Markdown notes editor and manager designed for elementary OS";
    homepage = https://github.com/Philip-Scott/Notes-up;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak worldofpeace ];
    platforms = platforms.linux;
  };
}

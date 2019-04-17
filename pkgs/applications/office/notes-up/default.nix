{ stdenv, fetchFromGitHub, pantheon, pkgconfig, cmake, ninja, gtk3, gtksourceview3, webkitgtk, gtkspell3, glib, libgee, sqlite, discount, wrapGAppsHook
, withPantheon ? false }:

stdenv.mkDerivation rec {
  pname = "notes-up";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Notes-up";
    rev = version;
    sha256 = "16bb9ffsg2csps1cb636rff5vc6f1yyhg65g3y5b4wf2hlbmzgql";
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

  # Whether to build with contractor support (Pantheon specific)
  cmakeFlags = if withPantheon then null else [ "-Dnoele=yes" ];

  meta = with stdenv.lib; {
    description = "Markdown notes editor and manager designed for elementary OS"
    + stdenv.lib.optionalString withPantheon " - built with Contractor support";
    homepage = https://github.com/Philip-Scott/Notes-up;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak worldofpeace ];
    platforms = platforms.linux;
  };
}

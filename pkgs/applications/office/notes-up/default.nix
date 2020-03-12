{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, vala
, cmake
, ninja
, gtk3
, gtksourceview3
, webkitgtk
, gtkspell3
, glib
, libgee
, sqlite
, discount
, wrapGAppsHook
, withPantheon ? false }:

stdenv.mkDerivation rec {
  pname = "notes-up";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Notes-up";
    rev = version;
    sha256 = "0bklgp8qrrj9y5m77xqbpy1ld2d9ya3rlxklgzx3alffq5312i4s";
  };

  nativeBuildInputs = [
    cmake
    ninja
    vala
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
  cmakeFlags = stdenv.lib.optional (!withPantheon) "-Dnoele=yes";

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Markdown notes editor and manager designed for elementary OS"
    + stdenv.lib.optionalString withPantheon " - built with Contractor support";
    homepage = https://github.com/Philip-Scott/Notes-up;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak worldofpeace ];
    platforms = platforms.linux;
  };
}

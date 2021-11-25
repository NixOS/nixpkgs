{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, vala
, cmake
, ninja
, gtk3
, gtksourceview3
, webkitgtk
, gtkspell3
, glib
, libgee
, pcre
, sqlite
, discount
, wrapGAppsHook
, withPantheon ? false
}:

stdenv.mkDerivation rec {
  pname = "notes-up";
  version = "unstable-2020-12-29";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Notes-up";
    rev = "2ea9f35f588769758f5d2d4436d71c4059141a6f";
    sha256 = "sha256-lKOM9+s34xYB9bF9pgip9DFu+6AaxSE4HjFVhoWtttk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    vala
    pkg-config
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
    pcre
    sqlite
    webkitgtk
  ];

  # Whether to build with contractor support (Pantheon specific)
  cmakeFlags = lib.optional (!withPantheon) "-Dnoele=yes";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Markdown notes editor and manager designed for elementary OS"
      + lib.optionalString withPantheon " - built with Contractor support";
    homepage = "https://github.com/Philip-Scott/Notes-up";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.philip-scott.notes-up";
  };
}

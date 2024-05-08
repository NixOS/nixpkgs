{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook3
, discount
, glib
, gtk3
, gtksourceview4
, gtkspell3
, libgee
, pantheon
, sqlite
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "notes-up";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Notes-up";
    rev = version;
    sha256 = "sha256-t9BCtdWd2JLrKTcmri1Lgl5RLBYD2xWCtMxoVXz0XPk=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    discount
    glib
    gtk3
    gtksourceview4
    gtkspell3
    libgee
    pantheon.granite
    sqlite
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Markdown notes editor and manager designed for elementary OS";
    homepage = "https://github.com/Philip-Scott/Notes-up";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.philip_scott.notes-up";
  };
}

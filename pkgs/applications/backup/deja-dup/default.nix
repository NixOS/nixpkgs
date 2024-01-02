{ lib, stdenv
, fetchFromGitLab
, substituteAll
, meson
, ninja
, pkg-config
, vala
, gettext
, itstool
, desktop-file-utils
, glib
, gtk4
, coreutils
, libsoup_3
, libsecret
, libadwaita
, wrapGAppsHook4
, libgpg-error
, json-glib
, duplicity
}:

stdenv.mkDerivation rec {
  pname = "deja-dup";
  version = "45.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "deja-dup";
    rev = version;
    hash = "sha256-2vNAppy8fYYcxH3ci4B6bUIl2sO5NC6yA13y9iU4V/A=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    libsoup_3
    glib
    gtk4
    libsecret
    libadwaita
    libgpg-error
    json-glib
  ];

  mesonFlags = [
    "-Dduplicity_command=${duplicity}/bin/duplicity"
  ];

  meta = with lib; {
    description = "A simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity \
      of backing up the Right Way (encrypted, off-site, and regular) \
      and uses duplicity as the backend.
    '';
    homepage = "https://wiki.gnome.org/Apps/DejaDup";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    mainProgram = "deja-dup";
  };
}

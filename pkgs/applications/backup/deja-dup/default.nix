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
<<<<<<< HEAD
  version = "44.2";
=======
  version = "44.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
<<<<<<< HEAD
    repo = "deja-dup";
    rev = version;
    hash = "sha256-TnyH2tIvzG1B2hbDPyFyaTArfuMJaP6GKw6yahwsQ1Q=";
=======
    repo = pname;
    rev = version;
    sha256 = "sha256-dIH6VPgzJxvXEUtPAYQzpQ8I9R9MwsfeylV25ASfW/k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  };
}

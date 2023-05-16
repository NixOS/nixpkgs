{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, vala
, gobject-introspection
, gtk4
, gtk3
, desktop-file-utils
}:

stdenv.mkDerivation {
  pname = "marble";
<<<<<<< HEAD
  version = "unstable-2023-05-11";
=======
  version = "unstable-2022-04-20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "marble";
<<<<<<< HEAD
    # the same used on flatpak
    rev = "f240b2ec7d5cdacb8fdcc553703420dc5101ffdb";
    sha256 = "sha256-obtz7zOyEZPgi/NNjtLr6aFm/1UVTzjTdJpN3JQfpUs=";
=======
    # Latest commit from the 'wip/gtk4' branch
    rev = "6dcc6fefa35f0151b0549c01bd774750fe6bdef8";
    sha256 = "sha256-0VJ9nyjWOOdLBm3ufleS/xcAS5YsSedJ2NtBjyM3uaY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gtk3 # For gtk-update-icon-cache
    desktop-file-utils # For update-desktop-database
    gobject-introspection # For g-ir-compiler
  ];
  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "Raggesilver's GTK library";
    homepage = "https://gitlab.gnome.org/raggesilver/marble";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}

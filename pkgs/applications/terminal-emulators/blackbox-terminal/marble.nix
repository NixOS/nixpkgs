{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gobject-introspection,
  gtk4,
  gtk3,
  desktop-file-utils,
}:

stdenv.mkDerivation {
  pname = "marble";
  version = "unstable-2023-05-11";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "marble";
    # the same used on flatpak
    rev = "f240b2ec7d5cdacb8fdcc553703420dc5101ffdb";
    sha256 = "sha256-obtz7zOyEZPgi/NNjtLr6aFm/1UVTzjTdJpN3JQfpUs=";
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

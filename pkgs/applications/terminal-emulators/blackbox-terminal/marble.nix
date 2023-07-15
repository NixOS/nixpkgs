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
  version = "unstable-2022-04-20";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "marble";
    # Latest commit from the 'wip/gtk4' branch
    rev = "6dcc6fefa35f0151b0549c01bd774750fe6bdef8";
    sha256 = "sha256-0VJ9nyjWOOdLBm3ufleS/xcAS5YsSedJ2NtBjyM3uaY=";
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

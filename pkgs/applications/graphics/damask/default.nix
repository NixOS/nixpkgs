{ lib
, stdenv
, fetchFromGitLab
, nix-update-script
, blueprint-compiler
, desktop-file-utils
, gettext
, gtk4
, json-glib
, libadwaita
, libgee
, libportal
, libportal-gtk4
, libsoup_3
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "damask";
  version = "0.1.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "subpop";
    repo = "damask";
    rev = "v${version}";
    sha256 = "sha256-CKt4CBwOjryXzvKdak/yWnT1OUZtDr8DugU6I1gXGzA";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gettext
    gtk4
    json-glib
    libadwaita
    libgee
    libportal
    libportal-gtk4
    libsoup_3
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Automatically set wallpaper images from Internet sources";
    homepage = "https://gitlab.gnome.org/subpop/damask";
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "damask";
  };
}

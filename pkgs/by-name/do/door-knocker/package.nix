{ stdenv
, lib
, fetchFromGitea
, blueprint-compiler
, desktop-file-utils
, glib
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "door-knocker";
  version = "0.4.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "tytan652";
    repo = "door-knocker";
    rev = finalAttrs.version;
    hash = "sha256-pC/Fv+GzHw0PTzJoDAUK/EzVVWXha2cflAqiznM9ZYM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Tool to check the availability of portals";
    homepage = "https://codeberg.org/tytan652/door-knocker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.linux;
    mainProgram = "door-knocker";
  };
})

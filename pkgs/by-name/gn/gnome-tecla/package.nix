{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
  libxkbcommon,
  wayland,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tecla";
  version = "48.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/tecla/${lib.versions.major finalAttrs.version}/tecla-${finalAttrs.version}.tar.xz";
    hash = "sha256-eD00ZNKiz36xUHZJ29n/Cc4khSwqbJoNNl24QGPT1AE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libxkbcommon
    wayland
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gnome-tecla";
      packageName = "tecla";
    };
  };

  meta = with lib; {
    description = "Keyboard layout viewer";
    homepage = "https://gitlab.gnome.org/GNOME/tecla";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
    mainProgram = "tecla";
  };
})

{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnome,
  gsound,
  gtk4,
  wrapGAppsHook4,
  librsvg,
  gettext,
  itstool,
  vala,
  libxml2,
  libadwaita,
  libgee,
  meson,
  ninja,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-nibbles";
  version = "4.4.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${lib.versions.majorMinor finalAttrs.version}/gnome-nibbles-${finalAttrs.version}.tar.xz";
    hash = "sha256-FuBgKHBkamZTh2y8Ye4j92NAwmsSyeicfDASCEUEQVU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    gettext
    itstool
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    gsound
    gtk4
    librsvg
    libadwaita
    libgee
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-nibbles"; };
  };

  meta = with lib; {
    description = "Guide a worm around a maze";
    mainProgram = "gnome-nibbles";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-nibbles";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-nibbles/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})

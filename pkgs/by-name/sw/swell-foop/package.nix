{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gtk4,
  libadwaita,
  libgee,
  libgnome-games-support_2_0,
  pango,
  gnome,
  desktop-file-utils,
  gettext,
  itstool,
  libxml2,
  wrapGAppsHook4,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swell-foop";
  version = "48.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/swell-foop/${lib.versions.major finalAttrs.version}/swell-foop-${finalAttrs.version}.tar.xz";
    hash = "sha256-h0AxrchfUtYzz2fVEkM0jyPmYOvkgvUIMldu+xPTebU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    python3
    itstool
    gettext
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libgee
    libgnome-games-support_2_0
    pango
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "swell-foop";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/swell-foop";
    changelog = "https://gitlab.gnome.org/GNOME/swell-foop/-/tree/${finalAttrs.version}?ref_type=tags";
    description = "Puzzle game, previously known as Same GNOME";
    mainProgram = "swell-foop";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
})

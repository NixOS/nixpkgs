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
  libgnome-games-support_2_0,
  meson,
  ninja,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-nibbles";
  version = "4.2.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${lib.versions.majorMinor finalAttrs.version}/gnome-nibbles-${finalAttrs.version}.tar.xz";
    hash = "sha256-Pkofm68cV7joNd7fCGnjJy5lNKHdacTib64QxCAKrwA=";
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
    libgnome-games-support_2_0
  ];

  # The "we can link with libadwaita?" valac.links() check fails otherwise.
  # Command line: `valac testfile.vala --pkg=libadwaita-1 --Xcc=-w --Xcc=-DVALA_STRICT_C` -> 1
  # testfile.vala.c:50:46: error: passing argument 2 of 'adw_about_dialog_set_developers'
  # from incompatible pointer type [-Wincompatible-pointer-types]
  # 50 |         adw_about_dialog_set_developers (ad, s);
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

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

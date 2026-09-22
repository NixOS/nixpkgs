{
  stdenv,
  lib,
  gettext,
  fetchurl,
  pkg-config,
  gtk4,
  glib,
  meson,
  ninja,
  upower,
  python3,
  desktop-file-utils,
  wrapGAppsHook4,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-power-manager";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-power-manager/${lib.versions.major finalAttrs.version}/gnome-power-manager-${finalAttrs.version}.tar.xz";
    hash = "sha256-vyQ9Y4n4v6cclYU07SZpspllxH9Vw8vkmDspbQ+Z5dc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext

    # needed by meson_post_install.sh
    python3
    glib
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    glib
    upower
  ];

  postPatch = ''
    substituteInPlace meson_post_install.sh \
      --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-power-manager"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-power-manager";
    description = "View battery and power statistics provided by UPower";
    mainProgram = "gnome-power-statistics";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})

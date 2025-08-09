{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  vala,
  pkg-config,
  gnome,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  librsvg,
  gettext,
  itstool,
  libxml2,
  libgnome-games-support_2_0,
  libgee,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-mines";
  version = "48.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${lib.versions.major finalAttrs.version}/gnome-mines-${finalAttrs.version}.tar.xz";
    hash = "sha256-70stLd477GFBV+3eTZGJzGr+aSlSot1VsocOLmLtgQQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgnome-games-support_2_0
    librsvg
    libgee
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-mines";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-mines";
    description = "Clear hidden mines from a minefield";
    mainProgram = "gnome-mines";
    teams = [ teams.gnome ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
})

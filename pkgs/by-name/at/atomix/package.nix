{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  python3,
  gettext,
  gnome,
  glib,
  gtk3,
  libgnome-games-support,
  gdk-pixbuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atomix";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atomix/${lib.versions.major finalAttrs.version}/atomix-${finalAttrs.version}.tar.xz";
    hash = "sha256-yISTF2iNh9pzTJBjA1YxBSAH8qh5m2xsyRUmWIC1X7Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook3
    python3
  ];

  buildInputs = [
    glib
    gtk3
    gdk-pixbuf
    libgnome-games-support
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "atomix"; };
  };

  meta = with lib; {
    description = "Puzzle game where you move atoms to build a molecule";
    mainProgram = "atomix";
    homepage = "https://gitlab.gnome.org/GNOME/atomix";
    changelog = "https://gitlab.gnome.org/GNOME/atomix/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
})

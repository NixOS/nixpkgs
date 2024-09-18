{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gnome,
  glib,
  gtk3,
  cairo,
  wrapGAppsHook3,
  libxml2,
  python3,
  gettext,
  itstool,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hitori";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/hitori/${lib.versions.major finalAttrs.version}/hitori-${finalAttrs.version}.tar.xz";
    hash = "sha256-QicL1PlSXRgNMVG9ckUzXcXPJIqYTgL2j/kw2nmeWDs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    desktop-file-utils
    libxml2
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    cairo
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "hitori"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/hitori";
    description = "GTK application to generate and let you play games of Hitori";
    mainProgram = "hitori";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
})

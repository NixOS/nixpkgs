{
  lib,
  stdenv,
  meson,
  ninja,
  gettext,
  fetchurl,
  pkg-config,
  gtk4,
  glib,
  libxml2,
  libadwaita,
  fribidi,
  wrapGAppsHook4,
  gnome,
  harfbuzz,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-font-viewer";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/${lib.versions.major finalAttrs.version}/gnome-font-viewer-${finalAttrs.version}.tar.xz";
    hash = "sha256-lWSwiMWxUMVOKjp7xwFN7sbuVRJh6YSI+JGx8bjca4A=";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook4
    libxml2
    glib
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    glib
    harfbuzz
    libadwaita
    fribidi
  ];

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/gnome-font-viewer.thumbnailer \
      --replace-fail "TryExec=gnome-thumbnail-font" "TryExec=$out/bin/gnome-thumbnail-font" \
      --replace-fail "Exec=gnome-thumbnail-font" "Exec=$out/bin/gnome-thumbnail-font"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-font-viewer";
    };
  };

  meta = {
    description = "Program that can preview fonts and create thumbnails for fonts";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-font-viewer";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  intltool,
  gtk3,
  gnome,
  adwaita-icon-theme,
  librsvg,
  pkg-config,
  pango,
  atk,
  gdk-pixbuf,
  hicolor-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-themes-extra";
  version = "3.28";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-extra/${lib.versions.majorMinor finalAttrs.version}/gnome-themes-extra-${finalAttrs.version}.tar.xz";
    hash = "sha256-fEugv/AB8G2Jg8/BBa2qxC3x0SZ6JZF5ingLrFV6WBk=";
  };

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-themes-extra";
    };
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    gtk3
  ];

  buildInputs = [
    gtk3
    librsvg
    pango
    atk
    gdk-pixbuf
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  configureFlags = [
    (lib.enableFeature false "gtk2-engine")
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/HighContrast
  '';

  meta = {
    platforms = lib.platforms.unix;
    teams = [ lib.teams.gnome ];
  };
})

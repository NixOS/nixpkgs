{
  lib,
  stdenv,
  fetchurl,
  intltool,
  gtk3,
  gnome,
  adwaita-icon-theme,
  pkg-config,
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
      packageName = finalAttrs.pname;
    };
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    intltool
    gtk3
    hicolor-icon-theme # its setup hook symlinks inherited parent icon themes
  ];
  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  postPatch = ''
    # The catalogues are installed and then deleted again, leaving empty directories.
    substituteInPlace Makefile.in \
      --replace-fail 'SUBDIRS = themes po' 'SUBDIRS = themes'

    # HighContrast is the one theme whose GTK2 part is not gated on the engine.
    substituteInPlace themes/HighContrast/Makefile.in \
      --replace-fail 'SUBDIRS = gtk-3.0 gtk-2.0 icons' 'SUBDIRS = gtk-3.0 icons'
  '';

  configureFlags = [
    "--disable-gtk2-engine"
    "--disable-gtk3-engine"
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/HighContrast
  '';

  meta = {
    description = "Dark Adwaita variant, GTK theme index files and the HighContrast icon theme";
    longDescription = ''
      What is left of the old GNOME 3 theme module now that GTK3 carries the
      Adwaita and HighContrast stylesheets itself: `Adwaita-dark`, so the dark
      variant can be picked by name; the `index.theme` entries appearance dialogs
      need to discover these themes on disk; and the HighContrast icons.
    '';
    homepage = "https://gitlab.gnome.org/GNOME/gnome-themes-extra";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.gnome ];
  };
})

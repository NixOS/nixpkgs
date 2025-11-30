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
  gtk2,
  gdk-pixbuf,
  hicolor-icon-theme,
}:

stdenv.mkDerivation rec {
  pname = "gnome-themes-extra";
  version = "3.28";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-extra/${lib.versions.majorMinor version}/gnome-themes-extra-${version}.tar.xz";
    hash = "sha256-fEugv/AB8G2Jg8/BBa2qxC3x0SZ6JZF5ingLrFV6WBk=";
  };

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
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
    gtk2
    gdk-pixbuf
  ];
  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/HighContrast
  '';

  meta = with lib; {
    platforms = platforms.unix;
    teams = [ teams.gnome ];
  };
}

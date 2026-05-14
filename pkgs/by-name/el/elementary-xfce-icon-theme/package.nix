{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gdk-pixbuf,
  optipng,
  librsvg,
  gtk3,
  pantheon,
  adwaita-icon-theme,
  gnome-icon-theme,
  hicolor-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-xfce-icon-theme";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "v${finalAttrs.version}";
    hash = "sha256-snNh6883YUmzU1OG8jLf41/0NrEzfwFikyVtX1JeNdw=";
  };

  nativeBuildInputs = [
    pkg-config
    gdk-pixbuf
    librsvg
    optipng
    gtk3
  ];

  propagatedBuildInputs = [
    pantheon.elementary-icon-theme
    adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    substituteInPlace svgtopng/Makefile --replace "-O0" "-O"
  '';

  postInstall = ''
    make icon-caches
  '';

  meta = {
    description = "Elementary icons for Xfce and other GTK desktops like GNOME";
    homepage = "https://github.com/shimmerproject/elementary-xfce";
    license = lib.licenses.gpl3Plus;
    # darwin cannot deal with file names differing only in case
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})

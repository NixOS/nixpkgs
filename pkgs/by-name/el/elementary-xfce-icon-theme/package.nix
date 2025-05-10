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

stdenv.mkDerivation rec {
  pname = "elementary-xfce-icon-theme";
  version = "0.21";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "v${version}";
    hash = "sha256-ncPL76HCC9n4wTciGeqb+YAUcCE9EeOpWGM5DRYUCYg=";
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

  meta = with lib; {
    description = "Elementary icons for Xfce and other GTK desktops like GNOME";
    homepage = "https://github.com/shimmerproject/elementary-xfce";
    license = licenses.gpl3Plus;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    teams = [ teams.xfce ];
  };
}

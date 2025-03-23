{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  autoreconfHook,
  gtk3,
  adwaita-icon-theme,
  moka-icon-theme,
  gnome-icon-theme,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "arc-icon-theme";
  version = "20161122";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "arc-icon-theme";
    rev = version;
    hash = "sha256-TfYtzwo69AC5hHbzEqB4r5Muqvn/eghCGSlmjMCFA7I=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gtk3
  ];

  propagatedBuildInputs = [
    moka-icon-theme
    adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postFixup = "gtk-update-icon-cache $out/share/icons/Arc";

  meta = with lib; {
    description = "Arc icon theme";
    homepage = "https://github.com/horst3180/arc-icon-theme";
    license = licenses.gpl3;
    # moka-icon-theme dependency is restricted to linux
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}

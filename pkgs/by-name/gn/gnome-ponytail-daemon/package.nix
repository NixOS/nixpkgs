{
  stdenv,
  lib,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "gnome-ponytail-daemon";
  version = "1.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ofourdan";
    repo = "gnome-ponytail-daemon";
    rev = "9dd3bda1816de216219232b8f6baec9f2d423ec6";
    hash = "";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
  ];

  meta = with lib; {
    description = "Sort of a bridge for dogtail for GNOME on Wayland";
    mainProgram = "gnome-ponytail-daemo";
    homepage = "https://gitlab.gnome.org/ofourdan/gnome-ponytail-daemon";
    license = licenses.gpl2Plus;
    platforms = qtbase.meta.platforms;
    maintainers = with maintainers; [ ];
  };
}

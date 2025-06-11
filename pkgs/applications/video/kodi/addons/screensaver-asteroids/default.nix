{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  pkg-config,
  glm,
  libGL,
}:
buildKodiBinaryAddon rec {
  pname = "screensaver-asteroids";
  namespace = "screensaver.asteroids";
  version = "22.0.2";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-Ri9dgdhJbHybdUkZeRE7X7SQMaV2JZCm7znAyDEa470=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    glm
    libGL
  ];

  meta = with lib; {
    homepage = "https://github.com/xbmc/screensaver.asteroids";
    description = "A screensaver that plays Asteroids";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    teams = [ teams.kodi ];
  };
}

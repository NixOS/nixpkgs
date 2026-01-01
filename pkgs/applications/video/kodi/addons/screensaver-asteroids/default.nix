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
  version = "21.0.2";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-cepo7amJn6y1J9hVSt35VgOz/ixT7l/UfjtmHOajBrw=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    glm
    libGL
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/xbmc/screensaver.asteroids";
    description = "Screensaver that plays Asteroids";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "https://github.com/xbmc/screensaver.asteroids";
    description = "Screensaver that plays Asteroids";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

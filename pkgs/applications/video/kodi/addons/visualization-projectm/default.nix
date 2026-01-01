{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  pkg-config,
  glm,
  libGL,
  projectm_3,
}:

buildKodiBinaryAddon rec {
  pname = "visualization-projectm";
  namespace = "visualization.projectm";
  version = "21.0.3";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-J3RtVl+hO8DspLyF2KAVMLDIJBiEb0bKosKhJyKy9hk=";
  };

  extraBuildInputs = [
    pkg-config
    libGL
    projectm_3
  ];

  propagatedBuildInputs = [ glm ];
<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/xbmc/visualization.projectm";
    description = "Projectm visualization for kodi";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "https://github.com/xbmc/visualization.projectm";
    description = "Projectm visualization for kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
